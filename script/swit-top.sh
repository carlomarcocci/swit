#!/bin/bash
LC_ALL="en_US.UTF-8"

TOUT=10
LIMIT=1.72
SERVERLIST='
eswuax.rm.ingv.it 
eswua.rm.ingv.it
'
date '+%Y-%m-%d %H:%M:%S'
for i in ${SERVERLIST}; do
    IFFA=`ssh  -o ConnectTimeout=$TOUT eswua@$i top -bn1 | head -n1 | awk '{print $12}' | sed 's/,//g'`
    if [ 1 -eq "$(echo "${IFFA} > ${LIMIT}" | bc)" ] ; then
        echo "`date '+%Y-%m-%d %H:%M:%S'` WARNING $i -> $IFFA"
        ssh  -o ConnectTimeout=$TOUT eswua@$i top -bn1 | head -n15
    else
        echo "    $i -> $IFFA"
    fi
done
echo "# ###########################"
