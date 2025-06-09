#!/bin/bash

# create a single file to create all db
# WARNING: remember to set the righe password in .env file

DBLIST="swit scint ais tecdb"
DBNAME=$1

# export  .env enviroment variables
set -a
. .env
set +a

for DBNAME in $DBLIST ; do
    echo "SELECT ' $DBNAME' AS DB_SEPARATOR;"
    for i in `find ./mydb/ -maxdepth 1 -name "*$DBNAME*" -name "*.sql" -type f | sort ` ; do
        echo "SELECT 'SOURCE_FILE $i' AS sourcefile;"
        cat $i | envsubst
    done
    echo "\\c $DBNAME"
    cat ./mydb/db_generic_function.sql | envsubst
done
