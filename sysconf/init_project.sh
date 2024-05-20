#!/bin/bash
listipa="   ais \
            scint \
            tec \
            hermes \
            hf
"

clear
PATTA="$HOME/git/swit"
# if .env doesnt exists create it
if [ ! -f "$PATTA/.env" ]; then
    grep -v '^#' "$PATTA/env.template" >> "$PATTA/.env"
    chmod 775 "$PATTA/.env"
fi

# export env variables in bash
export $(sed -E '/^\s*#/d; /^\s*$/d' "$PATTA/.env")

#export -p | grep PASS

# check existing system running
ISSAFE=`docker-compose ps | grep data | wc -l`
echo "$ISSAFE"
if [ $ISSAFE -eq 0 ]; then
    # empty datadir 
    docker run --rm -v $DEPLOYHOME/data:/data marcarlo/ionoparser rm -rf /data/
    
    # turn up docker 
    docker-compose up -d 
 
    # run wine fon the firse time to let it inizialized and avoid error message
    for i in $listipa ; do
        docker exec iparser_$i wine bin/ParseIsmrWin.exe -h > /dev/null 2>&1
        docker exec iparser_$i wine bin/ParseReduced.exe -h > /dev/null 2>&1
    done

    # create all database
    ${PATTA}/mydb/create-all-db.sh
else
    echo "system is up, please check docker-copose ps "
fi
