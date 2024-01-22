#!/bin/bash
listipa="   ais \
            scint \
            tec \
            hermes \
            hf
"
PATTA=`pwd`

for i in $listipa ; do
    docker exec iparser_tec wine bin/ParseIsmrWin.exe -h > /dev/null 2>&1
done

if [ ! -f .env ]; then
    cp ${PATTA}/env.template ${PATTA}/.env
fi

${PATTA}/mydb/create-all-db.sh
