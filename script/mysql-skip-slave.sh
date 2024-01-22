#!/bin/bash
if [ -z "$1" ]; then
        echo "numero di cicli"
        exit
fi
if [ -z "$2" ]; then
        echo "nome della stazione"
        exit
fi

MYSQLCMD="mysql --login-path=slave_root"

IN=$1
STA=$2
i=1
RUN_OK=1
while [ $i -le ${IN} ] && [ ${RUN_OK} -eq 1 ]; do
    ((i+=1))
    RUN_OUT=`${MYSQLCMD} -e "show slave status\G"`
    RUN_OUT=`echo "${RUN_OUT}" | grep Last_SQL_Error | grep Duplicate | grep ${STA}`
    
    RUN_MSG=`echo $RUN_OUT | awk '{ print $12 " " $13}'`
    RUN_OK=`echo "${RUN_OUT}" | grep Last_SQL_Error | grep Duplicate | grep ${STA} | wc -l`
    
#    echo "RUN_OUT $RUN_OUT"
#    echo "RUN_MSG $RUN_MSG"
#    echo "RUN_OK  $RUN_OK"
#exit
    echo "COUMT: $i DUP ${RUN_MSG}"
    if [ ${RUN_OK} -eq 1 ]; then
        ${MYSQLCMD} -e "stop slave"
        ${MYSQLCMD} -e "SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1;"
        ${MYSQLCMD} -e "start slave"
        #sleep 1
        #c-check-slave
    fi
    #RUN=`${MYSQLCMD} -e "show slave status\G" | grep Last_SQL_Error | grep Duplicate | grep mzs0p | wc -l`
done
echo "-----------------------------------------------------------"
${MYSQLCMD} -e "show slave status\G" | grep Last_SQL_Error
