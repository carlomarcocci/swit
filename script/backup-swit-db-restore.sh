#/bin/bash

MYSQL="/usr/bin/mysql --login-path=gianparoot "
PSQL="psql -U switu -h eswuadev.int.ingv.it swit -f "
DB="\
ais \
scintillation \
"

WORKDIR="/tmp/restore/"
FNAME=$1
FN=`basename $FNAME`

mkdir -p $WORKDIR
cp $FNAME $WORKDIR
cd $WORKDIR
tar xzf $WORKDIR$FN -C $WORKDIR

echo "restore tables"
for db in $DB; do 
    for i in `find $WORKDIR -type f -name "*$db*"`; do
        echo " -> $db <- $i"
        grep -e INSERT -e FOREIGN_KEY_CHECKS $i | $MYSQL $db -f
    done
done

echo ""
echo "swit"
for i in `find $WORKDIR -type f -name "*swit*.dmp"`; do
        echo " -> swit <- $i"
       $PSQL $i
done
