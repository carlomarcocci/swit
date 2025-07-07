#!/bin/bash

SYNTAX="
`basename $0` <days-number>
    es: $0 2
"

if [ -z "$1" ]; then
    echo "${SYNTAX}"
    exit
fi

NDAY=$1
STORE_DIR="/data/"
DEST_DIR="/dest"

NFILE=0
for CODE in ${CODE_LIST} ; do
    FILECP=0
    for ((i=0; i<${NDAY}; i++)) ; do
        CUR_DATE=$(date +%y%j -d "$DATE -$i day")   # date dir name
        CUR_DIR=${CODE}/${CUR_DATE}                 # sftp remote dir for code and date
        CUR_DIR_STORE=${STORE_DIR}${CUR_DIR}/       # local store dir for code and date
        #
        mkdir -p ${STORE_DIR}log
        mkdir -p ${CUR_DIR_STORE}
        #
        #docker run --rm -u 6666:6666 -v ${STORE_DIR}log:/data -v ${CUR_DIR_STORE}:/store gingv:0.3 rclone copy --log-level=INFO --log-file /data/out.log knmi:${CUR_DIR}/ /store/

        rclone copy --log-level=INFO --log-file ${STORE_DIR}log/out.log knmi:${CUR_DIR}/ ${CUR_DIR_STORE}/

        grep ismr ${STORE_DIR}log/out.log | awk '{print $5}' | sed s/:// > ${STORE_DIR}log/knmi.lst
        for fn in `cat ${STORE_DIR}log/knmi.lst`; do
            cp ${CUR_DIR_STORE}$fn ${DEST_DIR}
            ((FILECP=FILECP+1))
        done
        if [ $VERBOSE -gt 0 ] ; then
            echo "Sta: ${CODE} ${CUR_DATE} n: ${i} nfile: ${FILECP}"
        fi
        if [ $VERBOSE -gt 1 ] ; then
            cat ${STORE_DIR}log/knmi.lst
        fi
        rm -f ${STORE_DIR}log/knmi.lst
        rm -f ${STORE_DIR}log/out.log
        ((NFILE=FILECP+NFILE))
    done
done

if [ ${NFILE} -gt 0 ] ; then
    echo "NUM ISMR: ${NFILE}"
    echo "`date '+%Y-%m-%d %H:%M:%S'`"
    echo "-- " 
fi

