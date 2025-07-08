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

find ${TESTDATA} -type f -exec cp -f {} /data/swit/input/ais/ \;
gunzip -f /data/swit/input/ais/*.gz
echo ""
echo "-- --"
echo "    run iparse to pupulate dbs"
echo "# ######################################################################"

#docker exec iparser_ais ./load_dir stoppa 0
# NON viene testato il problema dei file zippati di dps4d

./ionoparser/run_iparser
