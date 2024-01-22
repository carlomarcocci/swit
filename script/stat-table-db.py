#!/usr/bin/python
import datetime
import sys
import mysql.connector
from mysql.connector import Error

# ubuntu connector
# apt-get install mysql-connector-pytho

slave_cnf = {
  'user': 'root',
  'password': 'password',
  'host': 'eswua-db.int.ingv.it',
  'database': 'information_schema',
  'raise_on_warnings': True
}
master_cnf = {
  'user': 'root',
  'password': 'password',
  'host': 'eswua.rm.ingv.it',
  'database': 'mystat'
  #'raise_on_warnings': True
}

print('Start')
print(datetime.datetime.now())
sys.stdout.flush()
try:
   # master_conn    = mysql.connector.connect(**master_cnf);
    slave_conn      = mysql.connector.connect(**slave_cnf);
    sql_select_Query= "SELECT TABLE_SCHEMA db FROM information_schema.TABLES WHERE TABLE_NAME='station' GROUP BY TABLE_SCHEMA;"
  #  sql_select_Query= "SELECT TABLE_SCHEMA db FROM information_schema.TABLES WHERE TABLE_NAME='station' GROUP BY TABLE_SCHEMA order by db desc limit 1;"
    cursor = slave_conn.cursor()
    cursor.execute(sql_select_Query)
    db_list = cursor.fetchall()
    #print("Total number of rows in station is: ", cursor.rowcount)
    cursor.close()
    
    for row in db_list:
        curr_db = row[0]
        print "Database selected: ", curr_db
        
        # lista delle tabelle possibili
        slave_cnf.update({'database': curr_db})
        slave_conn_db = mysql.connector.connect(**slave_cnf);

        cursor = slave_conn_db.cursor()
        sql_list_table = "SELECT code FROM station ORDER BY code"
        cursor.execute(sql_list_table)
        table_list = cursor.fetchall()
        cursor.close()
        
        # per ogni tabella seleziona i dati
        # nel caso del db ais per ogni stazione esistono tre tabelle con 
        # estensione diversa
        if curr_db == "ais":
            postfixtab = ["_auto", "_rdf", "_rev"]
        else:
            postfixtab = [""]
        for t in table_list:
            for p in postfixtab:
                curr_tbl = t[0] + p
                cursor = slave_conn.cursor()
                sql_exists_table = "SELECT COUNT(*) FROM TABLES WHERE TABLE_SCHEMA = %s AND TABLE_NAME = %s"
                cursor.execute(sql_exists_table, (curr_db, curr_tbl, ))
                exists = cursor.fetchone()
                cursor.close()            
                curr_tbl_exists = exists[0]
                if curr_tbl_exists == 1:
                    cursor = slave_conn_db.cursor()
                    sql_data_row = "SELECT CONCAT(YEAR(dt), '-', IF(MONTH(dt)>9,'','0'), MONTH(dt)) mese, COUNT(*) FROM " + curr_tbl + " GROUP BY mese"
                    cursor.execute(sql_data_row)
                    data_list = cursor.fetchall()
                    cursor.close()
                    master_conn     = mysql.connector.connect(**master_cnf);
                    for i in data_list:
                        cursor_master   = master_conn.cursor()
                        sql_ins_row     = "REPLACE INTO stat_tables (db_name, table_name, date_str, rows_num) VALUES(%s, %s, %s, %s)"
                        cursor_master.execute(sql_ins_row, (curr_db, curr_tbl, i[0], i[1], ))
                        master_conn.commit()
                        cursor_master.close()
                    master_conn.close()
                    print  "    ", datetime.datetime.now().time(), " PARSED ", curr_db, curr_tbl
                else:
                    print "    NOT EXISTS ", curr_db, curr_tbl
                sys.stdout.flush()
except Error as e:
    print("Error reading data from MySQL table", e)
finally:
    print 'End'
    print datetime.datetime.now()
    print('-----------------------------------')
    if (slave_conn.is_connected()):
        slave_conn.close()
        master_conn.close()
        cursor.close()
        print ("MySQL connection is closed")
