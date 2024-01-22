#!/bin/bash

MYSQLCMD="mysql --login-path=dataroot"
SECONDS_TOO_LONG=60
QUERIES_RUNNING_TOO_LONG=`${MYSQLCMD} -ANe"SELECT COUNT(1) FROM information_schema.processlist WHERE user='ws-reader' AND COMMAND <> 'Sleep' AND time >= ${SECONDS_TOO_LONG}"`
if [ ${QUERIES_RUNNING_TOO_LONG} -gt 0 ]
then
    echo "`date "+%Y-%m-%dT%T"` killed ${QUERIES_RUNNING_TOO_LONG} procs"
    KILLPROC_SQLSTMT="SELECT GROUP_CONCAT(CONCAT('KILL QUERY ',id,';') SEPARATOR ' ') KillQuery FROM information_schema.processlist WHERE user='ws-reader' AND time >= ${SECONDS_TOO_LONG}"
    ${MYSQLCMD} -ANe"${KILLPROC_SQLSTMT}" | ${MYSQLCMD}
fi

PRIMO=''
PRIMO=`/home/carlo/git/swit/script/kill_slowquery_pg.sh eswua.rm.ingv.it 5433 aisu ais $SECONDS_TOO_LONG`
if [[ $PRIMO != '' ]] ; then
    echo "--"
    echo $PRIMO
fi

PRIMO=`/home/carlo/git/swit/script/kill_slowquery_pg.sh eswua.rm.ingv.it 5432 tecu tecdb $SECONDS_TOO_LONG`
if [[ $PRIMO != '' ]] ; then
    echo "--"
    echo $PRIMO
fi
# | tr -d '\n'
