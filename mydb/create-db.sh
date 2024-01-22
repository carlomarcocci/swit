#!/bin/bash

# nella dir di bkup carica tutti i file con il nome del db nel nome
# i file sono stati creati cosi dallo script di backup
#

SYNTAX="
`basename $0` <db-name>
    es: $0 ais
"
if [ -z "$1" ]; then
        echo "${SYNTAX}"
        exit
fi

DATE=`date +%Y%m%d%H%M%S`
DBNAME=$1

# export delle var di ambiente in .env
export $(cat .env | xargs) && rails c

clear
# mydb 
# scintillation
echo "    - ${DBNAME}"
if [ "$DBNAME" = "scintillation" ]; then
    # creazione del nuovo db
    for i in `find ./mydb/ -maxdepth 1 -name "*$DBNAME*" -type f  | grep -v view | sort ` ; do
        echo "    - sending $i to mydb"
        cat $i | envsubst | docker exec -i data mydb -uroot -p$DATA_MYSQL_ROOT_PASSWORD -f
    done
    echo "SELECT TABLE_NAME, TABLE_ROWS FROM  information_schema.TABLES WHERE TABLE_SCHEMA='scintillation'" | docker exec -i data mydb -uroot -p$DATA_MYSQL_ROOT_PASSWORD
elif [ "$DBNAME" = "ais" ]; then
    for i in `find ./mydb/ -maxdepth 1 -name "*$DBNAME*" -or -name "pg_proc.sql" -type f  | grep -v view | sort ` ; do
        echo "    - sending $i"
        cat $i | envsubst | docker exec -i aispg  psql -U postgres
    done
    echo "\d+" | docker exec -i aispg  psql -U postgres $DBNAME
elif [ "$DBNAME" = "scint" ]; then
    for i in `find ./mydb/ -maxdepth 1 -name "pg_$DBNAME*" -or -name "pg_proc.sql" -type f  | grep -v view | sort ` ; do
        echo "    - sending $i"
        cat $i | envsubst | docker exec -i scintdb  psql -U postgres
    done
    echo "\d+" | docker exec -i scintdb  psql -U postgres $DBNAME
elif [ "$DBNAME" = "swit" ]; then
    echo "    - sending pg_swit_db.sql"
    cat ./mydb/pg_swit_db.sql | envsubst | docker exec -i datapg  psql -U postgres
    echo "\d+" | docker exec -i datapg  psql -U postgres $DBNAME
elif [ "$DBNAME" = "tecdb" ]; then
    echo "    - sending pg_swit_db.sql"
    for i in `find ./mydb/ -maxdepth 1 -name "*$DBNAME*" -or -name "pg_proc.sql" -type f  | grep -v view | sort ` ; do
        echo "    - sending $i"
        cat $i | envsubst | docker exec -i datapg  psql -U postgres
    done
    echo "\d+" | docker exec -i datapg  psql -U postgres $DBNAME
fi
