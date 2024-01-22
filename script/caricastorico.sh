
STAZ=$1
#for i in `find /sandata/eswua2/nas2t/archivio_scint/$STAZ/est_data -mindepth 1 -maxdepth 1 -name "2013" -type d | sort -h`; do
for i in `find /sandata/eswua2/nas2t/archivio_scint/$STAZ/est_data -mindepth 1 -maxdepth 1 -not -name "*00*"  -and -not -name "*2010*"  -and -not -name "*2011*" -and -not -name "*2012*" -and -not -name "*199*" -and -not -name "*198*" -type d | sort -h`; do
    NOME=`echo $i | sed 's/\/sandata\/eswua2\/nas2t\/archivio_scint\///'`

    echo "docker exec iparser_san ./load_dirnopause.sh data 3306 $NOME >> /sandata/prod/swit/logs/iparser/historic/iparser_san_$STAZ.log 2>&1"
    docker exec iparser_san ./load_dirnopause.sh data 3306 $NOME >> /sandata/prod/swit/logs/iparser/historic/iparser_san_$STAZ.log 2>&1
done
