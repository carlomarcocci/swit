#!/bin/bash

STOP="/home/eswua/git/swit/ionoparser/stop.int"

if [ -f /tmp/iparser_internal_logging_file ]; then
    read LOGFNAME </tmp/iparser_internal_logging_file
    read NFILE </tmp/iparser_internal_num_file
fi
if [ -z $1 ] ; then
    if [ -f ${STOP} ]; then
        echo "type:    ONE FILE"
    else
        echo "type:    ALL FILES"
    fi

   #FILE=`ps axl | grep iparser_internal | grep docker | grep bin | awk 'NF{NF-=1};1' | awk '{print $NF}'`
    FILE=`ps axl | grep iparser_internal | grep docker | wc -l`
    if [ ${FILE} -eq 0 ] ; then
        echo "loading  OFF"
        echo "last run"
    else
        echo "loading  ON"
        echo "running..".
    fi
    echo "log file name ${LOGFNAME}"
    echo "tot file num  ${NFILE}"
    echo "************************"
else
    LOGFNAME=$1
fi
if [ -f ${LOGFNAME} ]; then
    echo "file read     `cat ${LOGFNAME} | wc -l`"
    echo "OK            `grep OK_ ${LOGFNAME} | wc -l`"
    echo "noparsed      `grep NOPARSE ${LOGFNAME} | wc -l`"
    echo "duplicate     `grep "DUP\|OK_IDENTICAL_NOT_UPD" ${LOGFNAME} | wc -l`"
    echo "no data       `grep NO_PROFILE ${LOGFNAME} | wc -l`"
    echo "problem       `grep -v OK_ ${LOGFNAME} | grep -v NO_PROFILE | wc -l`"
    echo "°°°° tail log file °°°°"
    tail -n 4  ${LOGFNAME}
fi
