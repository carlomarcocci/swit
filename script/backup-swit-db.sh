#/bin/bash

# ###################################################
#   1 backup dei database di sistema per swit:
#       - swit su postgres
#           per la connessione usa il file .pgpass
#       - ais e scintillation nelle tabelle necessarie all'istallazione
#           per la connessione usa --login-path=dataroot
#   2 backup dei siti esposti su eswuax
#       - backup del db di joomla: per la connessione root usa --login-path=mysqlroot
#       - tar dei files delle dir www dei singoli siti
#   3 backup del sito cos su server cosweb
#       - usa docker mariadb per il dump del db con COS_MYSQL_ROOT_PASSWORD env definita
#   4 copia nella san, nel nas e su google drive di carlo.marcocci
# 
# ###################################################

MYSQLDUMP="/usr/bin/mysqldump "
PGDUMP="pg_dump -U postgres -h eswua.rm.ingv.it --inserts -c swit "

DATE=`date +%Y-%m-%d_%H%M`
TMPDI="/tmp/${DATE}"
TMPDIR="${TMPDI}/"
mkdir -p ${TMPDIR}

echo "-----------------------------------------------------------"
echo "`date +%Y-%m-%d\ %H:%M:%S` BACKUP START"
# dump delle tabelle di servizio dei db ais e scintillation
DB="\
ais \
scintillation \
"

TABELLE="\
station \
station_belong_institution \
status \
instrument \
institution \
"
for db in $DB ; do
    echo "`date +%Y-%m-%d\ %H:%M:%S` dump tables from $db"
    for i in ${TABELLE} ; do
        ${MYSQLDUMP} --login-path=dataroot --skip-opt ${db} $i | gzip - > ${TMPDIR}${DATE}_${db}_$i.dmp.gz
    done
done

echo "`date +%Y-%m-%d\ %H:%M:%S` dump swit database"
# dump del db swit per la gestione dei files in input
$PGDUMP | gzip - > ${TMPDIR}${DATE}_swit.dmp.gz

echo "`date +%Y-%m-%d\ %H:%M:%S` ionoweb on eswuax server"
LISTASITES=`ssh eswua@eswuax.rm.ingv.it ls /data/ionoweb/ | grep -v data | grep -v ftpd | grep -v TOREMOVE`
for i in $LISTASITES ; do
    echo "    `date +%Y-%m-%d\ %H:%M:%S` $i homedir"
    rsync -a eswua@eswuax.rm.ingv.it:/data/ionoweb/$i ${TMPDIR}${DATE}_$i
    tar czfP ${TMPDIR}${DATE}_$i.tar.gz ${TMPDIR}${DATE}_$i --remove-files
    echo "    `date +%Y-%m-%d\ %H:%M:%S` $i database joomla db"
    $MYSQLDUMP --login-path=mysqlxroot --skip-opt $i | gzip - > ${TMPDIR}${DATE}.$i.dmp.gz
done

echo "`date +%Y-%m-%d\ %H:%M:%S` eswuaj on eswua server"
echo "    `date +%Y-%m-%d\ %H:%M:%S` homedir"
rsync -a eswua@eswua.rm.ingv.it:/data/swit/web ${TMPDIR}${DATE}_eswuaj
tar czfP ${TMPDIR}${DATE}_eswyaj.tar.gz ${TMPDIR}${DATE}_eswuaj --remove-files
echo "    `date +%Y-%m-%d\ %H:%M:%S` joomla db"
$MYSQLDUMP  --login-path=mysqlroot --skip-opt eswuaj | gzip - > ${TMPDIR}${DATE}.eswuaj.dmp.gz

## bkup del sito cos
echo "`date +%Y-%m-%d\ %H:%M:%S` cos db dump on cosweb server"
docker run --rm -i mariadb mysqldump -uroot -p${COS_MYSQL_ROOT_PASSWORD} -hcosweb.rm.ingv.it --skip-opt cos | gzip - > ${TMPDIR}${DATE}.cos.dmp.gz
echo "`date +%Y-%m-%d\ %H:%M:%S` cos homedir on cosweb server"
rsync -a marcocci@cosweb.rm.ingv.it:/var/www ${TMPDIR}${DATE}_cos
tar czfP ${TMPDIR}${DATE}_cos.tar.gz ${TMPDIR}${DATE}_cos --remove-files

echo "`date +%Y-%m-%d\ %H:%M:%S` rclone"
rclone copy ${TMPDI} gcocci:swit/backup/ionoweb/
echo "`date +%Y-%m-%d\ %H:%M:%S` rsync"
rsync -a ${TMPDI} /mnt/sandata/data/backup/ionoweb/
rsync -a ${TMPDI} /mnt/swit/data/backup/ionoweb/

rm -fr ${TMPDIR}
