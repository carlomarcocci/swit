#!/bin/bash

# variables defined in docker run command
# 
# DRYRUN=0        # 0 or 1
# VERBOSE=0       # 0 or 1
# SSHTIMEOUT=10   # int value
# DAYSONHERMES=10

if [ $DRYRUN -gt 0 ] ; then
    RSYNC="rsync -axlv --dry-run --timeout=${SSHTIMEOUT} --exclude=.* "
else
    RSYNC="rsync -axlv --timeout=${SSHTIMEOUT} --exclude=.* "    
fi

USER_DMC="isacco_dmc"
USER_MZS="isacco_mzs"
HOST="hermes.enea.pnra.it"
STORAGEDIR="/data/"
DEST="/dest/"

# isacco_dmc@hermes.enea.pnra.it
# ##############################################à

# MZS
${RSYNC} ${USER_MZS}@${HOST}:~/from_mzs ${STORAGEDIR} > /tmp/list.mzs
# select files to copy in input dir
grep "\.ismr" /tmp/list.mzs | grep -v -P '\.[0-9]{4,}$' | grep -v '\.rsync-partial' > /tmp/2cp.mzs
grep "\.S60" /tmp/list.mzs | grep -v .tar | grep -v -P '\.[0-9]{4,}$' |  grep -v '\.rsync-partial' >> /tmp/2cp.mzs
# delete from server files older than DAYSONHERMES
if [ $DRYRUN -eq 0 ] ; then
#    ssh -o ConnectTimeout=${SSHTIMEOUT} ${USER_MZS}@${HOST} find from_mzs/ -not -ipath "*.rsync-partial*" -not -name ".*" -mtime +${}DAYSONHERMES -type f -exec rm {} \;
#    ssh -o ConnectTimeout=$SSHTIMEOUT ${USER_MZS}@${HOST} find from_mzs/ -type d -empty -delete
    # copy to input dir 
    mkdir -p ${DEST}mzs
    for i in `cat /tmp/2cp.mzs`; do
        cp ${STORAGEDIR}${i} ${DEST}mzs/
    done
fi
#
ISOUTMZS=`wc -l /tmp/2cp.mzs | awk '{print $1}'`

#
# DMC
${RSYNC} ${USER_DMC}@${HOST}:~/from_dmc $STORAGEDIR > /tmp/list.dmc

# SELECT FILES to copy in input dir
grep "\.ismr" /tmp/list.dmc | grep -v -P '\.[0-9]{4,}$' | grep -v '\.rsync-partial' > /tmp/2cp.dmc
grep "\.S60" /tmp/list.dmc | grep -v .tar | grep -v -P '\.[0-9]{4,}$' |  grep -v '\.rsync-partial' >> /tmp/2cp.dmc
# delete from server files older than DAYSONHERMES
if [ $DRYRUN -eq 0 ] ; then
#       ssh -o ConnectTimeout=$SSHTIMEOUT $USER_DMC@$HOST find from_dmc/ -not -ipath "*.rsync-partial*" -not -name ".*" -mtime +$DAYSONHERMES -type f -exec rm {} \;
#       ssh -o ConnectTimeout=$SSHTIMEOUT $USER_DMC@$HOST find from_dmc/ -type d -empty -delete
    # copy to input dir 
    mkdir -p ${DEST}dmc
    for i in `cat /tmp/2cp.dmc`; do
        cp $STORAGEDIR$i ${DEST}dmc/
    done
fi
#
ISOUTDMC=`wc -l /tmp/2cp.dmc | awk '{print $1}'` 

# output
if [[ ${ISOUTDMC} -gt 0 || ${ISOUTMZS} -gt 0 ]] ; then
    echo "`date '+%Y-%m-%d %H:%M:%S'`    start dmc"
    if [ ${ISOUTDMC} -gt 0 ] ; then
        if [ ${VERBOSE} -eq 1 ] ; then
            echo "LIST FILES:"
            cat /tmp/2cp.dmc
        fi
        echo "    DMC file: ${ISOUTDMC}"
    fi
    if [ ${ISOUTMZS} -gt 0 ] ; then
        if [ $VERBOSE -eq 1 ] ; then
            echo "LIST FILES:"
            cat /tmp/2cp.mzs
        fi
        echo "    MZS file: $ISOUTMZS"
    fi
fi

