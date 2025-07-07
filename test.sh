clear
cp ci_data_files/input/* /data/swit/input/tec_json/
gunzip /data/swit/input/tec_json/*
for i in `ls /data/swit/input/tec_json/` ; do
    ./iparse.sh $i; 
    echo $i[B;
done 
 
