#!/bin/bash
listipa="   ais \
            scint \
            tec \
            hermes \
            hf
"

clear
PATTA=$PWD

# if .env doesnt exists create it
if [ ! -f "$PATTA/.env" ]; then
    grep -v '^#' "$PATTA/env.template" >> "$PATTA/.env"
    chmod 775 "$PATTA/.env"
fi

# export env variables in bash
export $(sed -E '/^\s*#/d; /^\s*$/d' "$PATTA/.env")

#export -p | grep PASS

# check existing system running
ISSAFE=`docker-compose --env-file .env -f docker-compose.all.yml ps | grep datapg | wc -l`
echo "$ISSAFE"
if [ $ISSAFE -eq 0 ]; then

    # start docker container
    docker-compose --env-file .env -f docker-compose.all.yml up -d 
    
    sleep 20
    # run wine fon the firse time to let it inizialized and avoid error message
    for i in $listipa ; do
        docker exec iparser_$i wine bin/ParseIsmrWin.exe -h > /dev/null 2>&1
        docker exec iparser_$i wine bin/ParseReduced.exe -h > /dev/null 2>&1
    done

    # create all database
    echo "create db ${PATTA}/mydb/build-db-sql.sh"
    "${PATTA}/mydb/build-db-sql.sh" | grep -v ON_ERROR_STOP | envsubst | docker exec -i datapg  psql -U postgres 
    #"${PATTA}/mydb/build-db-sql.sh" | envsubst | docker exec -i datapg  psql -U postgres 

else
    echo "system is up, please check docker-compose --env-file .env -f docker-complete.yml ps  "
fi
