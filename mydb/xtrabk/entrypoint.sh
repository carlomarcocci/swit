#!/usr/bin/env bash

xtrabackup \
    --backup \
    --host=$DOCKERNAME \
    --user=root \
    --password=$ROOTPASS \
    --port=$MYPORT \
    --datadir=/var/lib/mysql \
    --target-dir=/xtrabackup_backupfiles

xtrabackup \
    --prepare \
    --target-dir=/xtrabackup_backupfiles

exit 0
