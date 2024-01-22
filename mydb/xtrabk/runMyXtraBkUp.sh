#!/bin/bash

SYNTAX="
`basename $0` <network> <docker-name> <port> <root-pass> <datadir> <backup-dir>

    es: $0 ionowwb_net mysql 3306 rootpass /data/eswuaxdata_v2/mysql_data /data/eswuaxdata_v2/xstra_bkup
    "
NETNAME=$1
DOCKERNAME=$2
PORT=$3
PASS=$4
DATADIR=$5
BKUPDIR=$6

if [ -z "$1" ]; then
    echo "${SYNTAX}"
    exit
fi
if [ -z "$2" ]; then
    echo "${SYNTAX}"
    exit
fi
if [ -z "$3" ]; then
    echo "${SYNTAX}"
    exit
fi

if [ -z "$4" ]; then
    echo "${SYNTAX}"
    exit
fi
if [ -z "$5" ]; then
    echo "${SYNTAX}"
    exit
fi
if [ -z "$6" ]; then
    echo "${SYNTAX}"
    exit
fi

#ISTHERE=`docker images  | grep percona-xtrabackup | wc -l`
#if [ $ISTHERE -eq 0 ]; then
#    echo "Download docker image..."
#    echo ""
#    docker pull perconalab/percona-xtrabackup
#fi

docker run -it \
    --network=$NETNAME \
    -e DOCKERNAME=$DOCKERNAME \
    -e ROOTPASS=$PASS \
    -e MYPORT=$PORT \
    -v $DATADIR:/var/lib/mysql \
    -v $BKUPDIR:/xtrabackup_backupfiles \
    myxtrabackup:v1
