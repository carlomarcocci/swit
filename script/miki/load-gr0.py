#!/usr/bin/python3.10

# #!/usr/bin/python3.9

def find_filepath(path, ext):
    matches = []
    for root, dirnames, filenames in os.walk(path):
        for filename in filenames:
            if filename.endswith((ext)):
                matches.append(os.path.join(root, filename))
#                print(matches)
#                return matches
    return matches

def readDataFromFile(fn): 
    # create empty lists
    datam   = {}
    data    = {}
    
    # open file for reading
    firstLine   = True
    with open(fn, 'r') as f:
        for line in f.readlines():
            if firstLine:
# Characteristic:foF2  Station:Gibilmanna  Month:07  Hour:09:30
                firstLine       = False
                # Characteristic
                datam.update({line.split()[0].split(':')[0]: line.split()[0].split(':')[1]})
                # Station
                datam.update({line.split()[1].split(':')[0]: line.split()[1].split(':')[1]})
                # Month:06
                datam.update({line.split()[2].split(':')[0]: line.split()[2].split(':')[1]})
                # Hour:10:10
                datam.update({line.split()[3].split(':')[0]: line.split()[3].split(':')[1] + ':' + line.split()[3].split(':')[2]})
            else:
                linearr = line.split()
                data.update({linearr[0]: linearr[1]})
  
    return datam, data

def connectdb():
    connection = psycopg2.connect(user="gridu",
                                  password="gridpass",
                                  host="172.18.2.3",
                                  port="5432",
                                  database="grid")
    return connection

def test_connection(cn):
    cur   = cn.cursor()
    cur.execute('select * from ciruzzo')
    lista = cur.fetchall()
    print(lista)
    cn.commit


def create_grid_table(cn):
    #try:
    cur   = cn.cursor()
    query       = """ CREATE TABLE IF NOT EXISTS grid0(
                        id              serial NOT NULL,
                        characteristic  varchar(20) NOT NULL,
                        station         varchar(20) NOT NULL,
                        month           int NOT NULL,
                        hour            time NOT NULL,
                        r12             int NOT NULL,
                        val             float NOT NULL,
                        PRIMARY KEY (id),
                        UNIQUE (month, station, hour, characteristic, r12)
                    );
                """
    cur.execute(query)

def insert_grid_row(cn, mt, mtx):
    query       =  """ INSERT INTO grid0   (characteristic,
                                            station,
                                            month,
                                            r12,
                                            hour,
                                            val
                                            ) VALUES (%s,%s,%s,%s,%s,%s)
                    """
    cur   = cn.cursor()
        
    for i in mtx:
        value = (   mt.get('Characteristic'),
                mt.get('Station'),
                mt.get('Month'),
                i,
                mt.get('Hour'),
                mtx[i])
        cur.execute(query, value)

    cn.commit()
 #   print("righe ins: ", cur.rowcount)
    cur.close()
                    
###########################
# main
###########################

import os
import json
import psycopg2

mycon = connectdb()
create_grid_table(mycon)

thisdir = os.getcwd()
for f in find_filepath( thisdir , '.gr0'):
    header, matrix  = readDataFromFile(f) 
#    print(f)
#    print("HEADER; ", header)
#    print(matrix)
    insert_grid_row(mycon, header, matrix)

mycon.commit()
mycon.close()

