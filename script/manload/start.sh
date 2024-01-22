
TIMEL=`date +%Y-%m-%d_%H%M%S`
LOGFNAME="/sandata/prod/swit/logs/iparser/historic/iparser_int.log.$TIMEL"
RUN=`ps axl | grep iparser_internal | grep docker | wc -l`
FNUM=`find internal_input/ -type f | wc -l`
if [ ${RUN} -eq 0 ] ; then
    echo ${LOGFNAME} > /tmp/iparser_internal_logging_file
    echo ${FNUM} > /tmp/iparser_internal_num_file
    echo "Started, logging at ${LOGFNAME}"
    docker exec iparser_internal ./load_dir_int.sh data 3306 >> ${LOGFNAME} 2>&1 &
else
    echo "iparser_internal is running"
fi
