#!/bin/bash

# a simle scritp to rotate log file from swit

SYNTAX="
`basename $0` <logs-dir>
    es: $0 /sandata/prod/swit/logs/iparser/ 
"


LOGDIR=$1
DATE=`date +%Y%m%d%H%M%S`

if [ -z "$1" ]; then
        echo "${SYNTAX}"
        exit
fi

RUNNUNG=`ps axl | grep load_dir | wc -l`
if [ ${RUNNUNG} -eq 1 ]; then
    for i in `find ${LOGDIR} -type f -iname "*.log"` ; do
	    mv -n ${i} ${i}.${DATE}
    done
else
    echo "ionoparser running.... retry kater"
fi
