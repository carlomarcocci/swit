#!/usr/bin/python
import mysql.connector
from mysql.connector import Error
import csv
from datetime import datetime

# ubuntu connector
# apt-get install mysql-connector-pytho

ROOT_PASS = os.getenv('DATA_MYSQL_ROOT_PASSWORD')
slave_cnf = {
  'user': 'root',
  'password': ROOT_PASS,
  'host': 'eswua-db.int.ingv.it',
  'database': 'scintillation',
  'raise_on_warnings': True
}

try:
    slave_conn = mysql.connector.connect(**slave_cnf);
    sql_select_Query = "select code from station where code like '%s';"
    cursor = slave_conn.cursor()
    cursor.execute(sql_select_Query)
    table_list = cursor.fetchall()
    #print("Total number of rows in station is: ", cursor.rowcount)
    cursor.close()
    now = datetime.now()
    dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
    print "time; ", dt_string
    
    fatti=[]
    for i in table_list:
        tab1 = i[0]
        for j in table_list:
            tab2 = j[0]
            if not tab2 in fatti and tab1 != tab2:
                print "tabelle ", tab1, tab2
                sql_select_Query = "SELECT a.dt, a.svid, f1.name, f2.name, f1.modified, f2.modified FROM " + tab1 + " a JOIN " + tab2 + " b ON a.dt=b.dt AND a.svid=b.svid AND a.rxstate=b.rxstate AND a.azimuth=b.azimuth AND a.elevation=b.elevation AND a.averagel1=b.averagel1 AND a.totals4l1=b.totals4l1 AND a.corrections4l1=b.corrections4l1 AND a.phi01l1=b.phi01l1 AND a.phi03l1=b.phi03l1 AND a.phi10l1=b.phi10l1 AND a.phi30l1=b.phi30l1 AND a.phi60l1slant=b.phi60l1slant AND a.avgccdl1=b.avgccdl1 AND a.sigmaccdl1=b.sigmaccdl1 AND a.tec45=b.tec45 AND a.dtec60_45=b.dtec60_45 AND a.tec30=b.tec30 AND a.dtec45_30=b.dtec45_30 AND a.tec15=b.tec15 AND a.dtec30_15=b.dtec30_15 AND a.tec0=b.tec0 AND a.dtec0=b.dtec0 AND a.locktimel1=b.locktimel1 AND a.chanstatus=b.chanstatus AND a.2ndlocktime=b.2ndlocktime AND a.avgcn2freqtec=b.avgcn2freqtec JOIN file f1 ON f1.id=a.fk_file JOIN file f2 ON f2.id=b.fk_file"
    
                #sql_select_Query = "SELECT %s " + tab1 + ", %s " + tab2 
                cursor = slave_conn.cursor()
                #cursor.execute(sql_select_Query, (tab1, tab2, ))
                cursor.execute(sql_select_Query)
                table_out = cursor.fetchall()
                print "    duplicate rows: ", cursor.rowcount
                cursor.close()
                now = datetime.now()
                dt_string = now.strftime("%Y-%m-%d %H:%M:%S")
                print "    time; ", dt_string
                with open(tab1+"_"+tab2+".dupe","w+") as f:
                    writer = csv.writer(f, delimiter=',')
                    writer.writerows(table_out)  #considering my_list is a list of lists.
        
        fatti.append(tab1)

except Error as e:
    print("Error reading data from MySQL table", e)
finally:
    if (slave_conn.is_connected()):
        slave_conn.close()
        cursor.close()
        print("MySQL connection is closed")
