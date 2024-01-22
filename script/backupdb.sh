#!/bin/bash

######################################################################
# script che esegue il bkup dei databases residenti su docker
# il docker e il nome del db da dumpare vanno passati come parametri
######################################################################

#ISTEST="--no-data"

SYNTAX="
`basename $0` docker_name db_name

    es: $0 eswua_site_db_v10 wordpress
"

HOST=$1
LIST_DB_TO_BACKUP=$2

if [ -z "$1" ]; then
        echo "${SYNTAX}"
        exit
fi
if [ -z "$2" ]; then
        echo "${SYNTAX}"
        exit
fi

echo $HOST
echo $LIST_DB_TO_BACKUP

PASS="eswua_data_db"
DIR="/data/eswuaxdata_v2/dati/backup/db/"

MYSQLCMD="docker exec -i ${HOST} /usr/bin/mysql -uroot -p${PASS} "
MYDMPCMD="docker exec -i ${HOST} /usr/bin/mysqldump -uroot -p${PASS} ${ISTEST} "
SENDMAILCMD="mail -s \"${SUBMAIL}\" -r carlo.marcocci@ingv.it carlo.marcocci@ingv.it"

DIRW="${DIR}`date +%Y-%m-%d`"
FNAME=`date +%Y-%m-%d-%H-%M`
FILEOUT=${DIRW}/${HOST}_${FNAME}.out

PREFIXSUBMAIL="DB ADMIN ${HOST} Bkup:"

echo $DIRW
echo $FNAME
echo $FILEOUT

if [ ! -d "$DIRW" ]; then
    mkdir ${DIRW}
fi

echo "start-time:" > ${FILEOUT}
date >> ${FILEOUT}
echo "------------------------------------------------------" >> ${FILEOUT}
echo "" >> ${FILEOUT}

# LIST_DB_TO_BACKUP=`${MYSQLCMD} --column-names=FALSE -B -e "SHOW DATABASES;"`

# Dump all grants on host
# ${MYSQL_SHOW_GRANTS_FOR_ALL} ${HOST} ${PASS} > ${FILEGRANTS}

echo "" >> ${FILEOUT}

for f in ${LIST_DB_TO_BACKUP}; do
    echo "Backup database ${f} ..." >> ${FILEOUT}
    DIRDB="${DIRW}/${f}/"
    if [ ! -d "$DIRDB" ]; then
        mkdir ${DIRDB}
    fi
    LIST_TABLE=`${MYSQLCMD} --column-names=FALSE -B ${f} -e "SHOW TABLES;"`
    ${MYDMPCMD} --no-data --trigger --routines --master-data -uroot ${f} 2>> ${FILEOUT} | gzip -  >  ${DIRDB}${f}.skt.gz
    for t in ${LIST_TABLE}; do
        ${MYDMPCMD} ${ISTEST} --disable-keys --skip-lock-tables --quick --extended_insert --skip-add-locks ${f} ${t} 2>> ${FILEOUT} | gzip -  >  ${DIRDB}${f}-${t}.dmp.gz
    echo "  ${t}" >> ${FILEOUT}
    done
    echo "End Backup database ${f}." >> ${FILEOUT}
    echo "" >> ${FILEOUT}
done

SQLRUN="Yes"
if [ "${SQLRUN}" != "Yes" ] || [ "${IORUN}" != "Yes" ]; then
    SUBMAIL="${PREFIXSUBMAIL} Problem"
else
    SUBMAIL="${PREFIXSUBMAIL} Completed"    
fi

echo "" >> ${FILEOUT}
echo "------------------------------------------------------" >> ${FILEOUT}
echo "" >> ${FILEOUT}
ls -lth ${DIRW} >> ${FILEOUT}
echo "" >> ${FILEOUT}
echo "------------------------------------------------------" >> ${FILEOUT}
echo "end-time:" >> ${FILEOUT}
date >> ${FILEOUT}

cat ${FILEOUT} | ${SENDMAILCMD}

