#!/bin/bash

SYNTAX="
`basename $0` <test-data-path>
    es: $0 /home/carlo/Downloads/data/test/
"
if [ -z "$1" ]; then
        echo "${SYNTAX}"
        exit
fi
TESTDATA=$1

echo "# ######################################################################"
echo "    initialize system"
echo "# ######################################################################"

# ./init_project.sh

echo ""
echo "# ######################################################################"
echo "    fill input dir"
echo "# ######################################################################"

find ${TESTDATA} -type f -exec cp {} /data/swit/input/ais/ \;

echo ""
echo "# ######################################################################"
echo "    run iparse to pupulate dbs"
echo "# ######################################################################"

docker exec iparser_ais ./load_dir stoppa 0
