#!/usr/bin/python3.10

# #!/usr/bin/python3.9

def find_filepath(path, ext):
    matches = []
    for root, dirnames, filenames in os.walk(path):
        for filename in filenames:
            if filename.endswith((ext)):
                matches.append(os.path.join(root, filename))
                #return matches
    return matches

def readDataFromFile(fn): 
    # create empty lists
    datam   = {}
    data    = {}
    dataar  = []
    
    # open file for reading
    firstLine   = True
    with open(fn, 'r') as f:
        for line in f.readlines():
            if firstLine:
                firstLine       = False
                # Characteristic
                datam.update({line.split()[0].split(':')[0]: line.split()[0].split(':')[1]})
                # Month:06
                datam.update({line.split()[1].split(':')[0]: line.split()[1].split(':')[1]})
                # R12:+195
                datam.update({line.split()[2].split(':')[0]: line.split()[2].split(':')[1]})
                # Hour:10:10
                datam.update({line.split()[3].split(':')[0]: line.split()[3].split(':')[1] + ':' + line.split()[3].split(':')[2]})
            else:
                linearr = line.split()
                fcol = True
                nlon = 5
                for d in linearr:
                    if fcol:
                        rlat = d
                        fcol = False
                    else:
                        # longitudini che vanno da 5° a 20°, con step di 1°
                        dataar.append({'lat': rlat, 'lon': nlon, datam['Characteristic']: d})
                        nlon +=1 
  
    return datam, dataar

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
    query       = """ CREATE TABLE IF NOT EXISTS grid1(
                        id              serial NOT NULL,
                        characteristic  varchar(20) NOT NULL,
                        month           int NOT NULL,
                        r12             int NOT NULL,
                        hour            time NOT NULL,
                        matrix          jsonb NOT NULL,
                        PRIMARY KEY (id),
                        UNIQUE (month, hour, characteristic, r12)
                    );
                """
    cur.execute(query)

def insert_grid_row(cn, mt, mtx):
    query       =  """ INSERT INTO grid1   (characteristic,
                                            month,
                                            r12,
                                            hour,
                                            matrix
                                            ) VALUES (%s,%s,%s,%s,%s)
                    """
    cur   = cn.cursor()
        
    value = (   mt.get('Characteristic'), 
                mt.get('Month'),
                mt.get('R12'),
                mt.get('Hour'),
                json.dumps(mtx))
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
for f in find_filepath( thisdir , '.gr1'):
    header, matrix  = readDataFromFile(f) 
#    print(f)
#    print("HEADER; ", header)
    insert_grid_row(mycon, header, matrix)

mycon.commit()
mycon.close()

