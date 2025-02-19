#!/bin/bash

# create a single file to create all db
# WARNING: remember to set the righe password in .env file

DBLIST="swit scint ais tecdb"
DBNAME=$1

# export delle var di ambiente in .env
set -a
. .env
set +a

#echo "docker exec -i $DBHOST psql -U postgres"

for DBNAME in $DBLIST ; do
    echo "SELECT ' $DBNAME' AS DB_SEPARATOR;"
    for i in `find ./mydb/ -maxdepth 1 -name "*$DBNAME*" -name "*.sql" -type f | sort ` ; do
        echo "SELECT 'SOURCE_FILE $i' AS sourcefile;"
        cat $i | envsubst
    done
#    cat mydb/db_generic_function.sql | envsubst
#exit    
done
