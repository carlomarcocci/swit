#!/bin/bash

SYNTAX="
`basename $0` <test-data-path>
    es: $0 ci_data_files/input/
"
if [ -z "$1" ]; then
        echo "${SYNTAX}"
        exit
fi
TESTDATA=$1

clear
echo ""
echo "# ######################################################################"
echo "    fill input dir"
echo "# ######################################################################"

find ${TESTDATA} -type f -exec cp {} /data/swit/input/ais/ \;

echo ""
echo "    run iparse to pupulate dbs"
echo "# ######################################################################"

docker exec iparser_ais ./load_dir stoppa 0
# per il workaround dei file zippati di dps4d
docker exec iparser_ais ./load_dir stoppa 0
