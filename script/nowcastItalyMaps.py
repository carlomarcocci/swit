# -*- coding: utf-8 -*-
"""
Created on Wed Apr  3 03:30:16 2019

@author: ASTROGEO
"""

import datetime
import sys
import shutil
import mysql.connector

path_maps_foF2 = str(sys.argv[1])
path_maps_M3 = str(sys.argv[2])
path_previsti = str(sys.argv[3])
path_web_space_GIFINT = str(sys.argv[4])

#path_maps_foF2 = "D:/Python_IRI/test_GIFINT_Italia/mapsfof2_R12/"
#path_maps_M3 = "D:/Python_IRI/test_GIFINT_Italia/mapsm3000f2_R12/"
#path_previsti = "D:/Python_IRI/test_GIFINT_Italia/previsti/"
#path_web_space_GIFINT = "D:/Python_IRI/test_GIFINT_Italia/web_space/"

#*********************************************************
# START obtaining year, month, day, day of the year, hour
#*********************************************************

#obtain year, month, day and hour from the system
actual_date = datetime.datetime.now()

processing_year = str(actual_date.year)
#print (processing_year)

processing_month = str(actual_date.month)
if len(processing_month)<2:
    processing_month = "0" + (processing_month)

#print (processing_month)
    
if processing_month == "01":
    processing_month_string = "Jan"
elif processing_month == "02":
    processing_month_string = "Feb"
elif processing_month == "03":
    processing_month_string = "Mar"
elif processing_month == "04":
    processing_month_string = "Apr"
elif processing_month == "05":
    processing_month_string = "May"
elif processing_month == "06":
    processing_month_string = "Jun"
elif processing_month == "07":
    processing_month_string = "Jul"
elif processing_month == "08":
    processing_month_string = "Aug"
elif processing_month == "09":
    processing_month_string = "Sep"
elif processing_month == "10":
    processing_month_string = "Oct"
elif processing_month == "11":
    processing_month_string = "Nov"
elif processing_month == "12":
    processing_month_string = "Dec"
#print (processing_month_string)
    
processing_day = str(actual_date.day)
if len(processing_day)<2:
    processing_day = "0" + (processing_day)

#print (processing_day)

#the following instruction put the time in UTC
processing_hour = str(datetime.datetime.utcnow().hour)
#processing_hour = str(actual_date.hour)

if len(processing_hour)<2:
    processing_hour = "0" + (processing_hour)

#print (processing_hour)

date_hour_Carlo_DB = processing_year + "-" + processing_month + "-" + processing_day + " " + processing_hour + ":00:00"

print (date_hour_Carlo_DB)
    
#*********************************************************
# END obtaining year, month, day, day of the year, hour
#*********************************************************
    
#*********************************************************
# START reading foF2 and M(3000)F2 from the database
#*********************************************************

cnx = mysql.connector.connect(user='eswuaj', password= os.environ.get('ESWUAJ_JOOMLA_DB_PASSWORD'),
                              host='eswua.rm.ingv.it',
                              database='ais')

cursor = cnx.cursor()

#date_hour_Carlo_DB = '2020-06-23 12:00:00' #data
#date_hour_Carlo_DB = '2020-06-24 14:00:00' #no data
#date_hour_Carlo_DB = '2020-07-18 07:00:00' #no ionogram
#date_hour_Carlo_DB = '2020-06-26 06:00:00' #data

# READ Rome autoscaled file from database
query   = "SELECT fof2, m3000f2 FROM rm041_auto WHERE dt = '" + str(date_hour_Carlo_DB) + "' "
#query   = "SELECT fof2, m3000f2 FROM rm041_auto WHERE fof2 is not null AND MINUTE(dt)=0 ORDER BY dt DESC LIMIT 1 "

cursor.execute(query)

records = cursor.fetchall()
print("Total number of rows in Laptop is: ", cursor.rowcount)

if cursor.rowcount == 0:
    print ("0 row")
    foF2_Rome_db = "None"
    M3_Rome_db = "None"
    
if cursor.rowcount != 0:
    for row in records:
        print("fof2_Rome_db = ", row[0])
        print("m3000f2_Rome_db = ", row[1])
    
        foF2_Rome_db = str(row[0])
        M3_Rome_db = str(row[1])
        
        
# READ Gibilmanna autoscaled file from database
query   = "SELECT fof2, m3000f2 FROM gm037_auto WHERE dt = '" + str(date_hour_Carlo_DB) + "' "

cursor.execute(query)

records = cursor.fetchall()
print("Total number of rows in Laptop is: ", cursor.rowcount)

if cursor.rowcount == 0:
    print ("0 row")
    foF2_Gibi_db = "None"
    M3_Gibi_db = "None"
    
if cursor.rowcount != 0:
    for row in records:
        print("fof2_Gibi_db = ", row[0])
        print("m3000f2_Gibi_db = ", row[1])
    
        foF2_Gibi_db = str(row[0])
        M3_Gibi_db = str(row[1])

# Close database connections
        
cursor.close()
cnx.close()

M3_Rome = M3_Rome_db
print ("m3000f2_Rome = ", M3_Rome)

M3_Gibi = M3_Gibi_db
print ("m3000f2_Gibi = ", M3_Gibi)

foF2_Rome = foF2_Rome_db
print ("fof2_Rome = ", foF2_Rome)

foF2_Gibi = foF2_Gibi_db
print ("fof2_Rome = ", foF2_Gibi)

#*************************************************************************
# END reading foF2 and M(3000)F2 of Rome and Gibilmanna from the database
#*************************************************************************

#*******************************
# START procedure M(3000)F2 map
#*******************************
    
# no value is available, neither at Rome nor at Gibilmanna
if (M3_Rome == "None" and M3_Gibi == "None"):
    print ("test_1_M3")
    shutil.copy(path_maps_M3 + "no_data_M3.gif", \
                  path_web_space_GIFINT + "current_M3.gif")
      
# only the value of Rome is available
elif (M3_Rome != "None" and M3_Gibi == "None"):
    M3_forecasted_file_Rome=open(path_previsti + "M3_mm" + \
                                processing_month + "_hh" + processing_hour + "_Rom" \
                                + '.txt','r')
    
    difference_M3_Rome = 10000
    for line in M3_forecasted_file_Rome:
        #print(line)
        #print line[8,12]
        temporary_difference = abs(float(M3_Rome) - float(line[8:12]))
        #print temporary_difference
        if temporary_difference < difference_M3_Rome:
            difference_M3_Rome = temporary_difference
            effective_index_M3_Rome = line[0:3]
    
    M3_forecasted_file_Rome.close()
    shutil.copy(path_maps_M3 + "m3" + processing_month_string + ".Maps/" + \
                  "m3" + processing_month_string + effective_index_M3_Rome + ".Maps/" + \
                  processing_month + processing_hour + effective_index_M3_Rome + ".gif", \
                  path_web_space_GIFINT + "current_M3.gif")
    
# only the value of Gibilmanna is available
elif (M3_Rome == "None" and M3_Gibi != "None"):
    M3_forecasted_file_Gibi=open(path_previsti + "M3_mm" + \
                                processing_month + "_hh" + processing_hour + "_Gib" \
                                + '.txt','r')
    
    difference_M3_Gibi = 10000
    for line in M3_forecasted_file_Gibi:
        #print(line)
        #print line[8,12]
        temporary_difference = abs(float(M3_Gibi) - float(line[8:12]))
        #print temporary_difference
        if temporary_difference < difference_M3_Gibi:
            difference_M3_Gibi = temporary_difference
            effective_index_M3_Gibi = line[0:3]
    
    M3_forecasted_file_Gibi.close()
    shutil.copy(path_maps_M3 + "m3" + processing_month_string + ".Maps/" + \
                  "m3" + processing_month_string + effective_index_M3_Gibi + ".Maps/" + \
                  processing_month + processing_hour + effective_index_M3_Gibi + ".gif", \
                  path_web_space_GIFINT + "current_M3.gif")
    
# both the value of Gibilmanna and that of Rome are available
elif (M3_Rome != "None" and M3_Gibi != "None"):
    #print "prova"
    M3_forecasted_file_Rome=open(path_previsti + "M3_mm" + \
                                processing_month + "_hh" + processing_hour + "_Rom" \
                                + '.txt','r')
    
    M3_forecasted_file_Gibi=open(path_previsti + "M3_mm" + \
                                processing_month + "_hh" + processing_hour + "_Gib" \
                                + '.txt','r')
    
    delta_M3 = 10000
    
    for line_Rome in M3_forecasted_file_Rome:
        line_Gibi = M3_forecasted_file_Gibi.readline()
        
        temporary_delta_M3 = (float(M3_Rome) - float(line_Rome[8:12]))**2 + \
                     (float(M3_Gibi) - float(line_Gibi[8:12]))**2
        temporary_delta_M3 = temporary_delta_M3/2
        
        if temporary_delta_M3 < delta_M3:
            delta_M3 = temporary_delta_M3
            effective_index_M3 = line_Rome[0:3] #here we could have written also line_Gibi[0:3]
        
    #print "effective_index_M3"
    #print effective_index_M3
        
    M3_forecasted_file_Rome.close()
    M3_forecasted_file_Gibi.close()
    shutil.copy(path_maps_M3 + "m3" + processing_month_string + ".Maps/" + \
                  "m3" + processing_month_string + effective_index_M3 + ".Maps/" + \
                  processing_month + processing_hour + effective_index_M3 + ".gif", \
                  path_web_space_GIFINT + "current_M3.gif")

#*****************************
# END procedure M(3000)F2 map
#*****************************
    
#***************************
# START procedure foF2 map
#***************************

# no value is available, neither at Rome nor at Gibilmanna
if (foF2_Rome == "None" and foF2_Gibi == "None"):
    print ("test_1_fof2")
    shutil.copy(path_maps_foF2 + "no_data_foF2.gif", \
                  path_web_space_GIFINT + "current_foF2.gif")
      
# only the value of Rome is available
elif (foF2_Rome != "None" and foF2_Gibi == "None"):
    print ("test_2_fof2")
    foF2_forecasted_file_Rome=open(path_previsti + "foF2_mm" + \
                                processing_month + "_hh" + processing_hour + "_Rom" \
                                + '.txt','r')
    
    difference_foF2_Rome = 10000
    for line in foF2_forecasted_file_Rome:
        #print(line)
        #print line[8,12]
        temporary_difference = abs(float(foF2_Rome) - float(line[8:12]))
        #print temporary_difference
        if temporary_difference < difference_foF2_Rome:
            difference_foF2_Rome = temporary_difference
            effective_index_foF2_Rome = line[0:3]
    
    foF2_forecasted_file_Rome.close()
    shutil.copy(path_maps_foF2 + "f2" + processing_month_string + ".Maps/" + \
                  "f2" + processing_month_string + effective_index_foF2_Rome + ".Maps/" + \
                  processing_month + processing_hour + effective_index_foF2_Rome + ".gif", \
                  path_web_space_GIFINT + "current_foF2.gif")
    
# only the value of Gibilmanna is available
elif (foF2_Rome == "None" and foF2_Gibi != "None"):
    foF2_forecasted_file_Gibi=open(path_previsti + "foF2_mm" + \
                                processing_month + "_hh" + processing_hour + "_Gib" \
                                + '.txt','r')
    
    difference_foF2_Gibi = 10000
    for line in foF2_forecasted_file_Gibi:
        #print(line)
        #print line[8,12]
        temporary_difference = abs(float(foF2_Gibi) - float(line[8:12]))
        #print temporary_difference
        if temporary_difference < difference_foF2_Gibi:
            difference_foF2_Gibi = temporary_difference
            effective_index_foF2_Gibi = line[0:3]
    
    foF2_forecasted_file_Gibi.close()
    shutil.copy(path_maps_foF2 + "f2" + processing_month_string + ".Maps/" + \
                  "f2" + processing_month_string + effective_index_foF2_Gibi + ".Maps/" + \
                  processing_month + processing_hour + effective_index_foF2_Gibi + ".gif", \
                  path_web_space_GIFINT + "current_foF2.gif")
    
# both the value of Gibilmanna and that of Rome are available
elif (foF2_Rome != "None" and foF2_Gibi != "None"):
    #print "prova"
    foF2_forecasted_file_Rome=open(path_previsti + "foF2_mm" + \
                                processing_month + "_hh" + processing_hour + "_Rom" \
                                + '.txt','r')
    
    foF2_forecasted_file_Gibi=open(path_previsti + "foF2_mm" + \
                                processing_month + "_hh" + processing_hour + "_Gib" \
                                + '.txt','r')
    
    delta_foF2 = 10000
    
    for line_Rome in foF2_forecasted_file_Rome:
        line_Gibi = foF2_forecasted_file_Gibi.readline()
        
        temporary_delta_foF2 = (float(foF2_Rome) - float(line_Rome[8:12]))**2 + \
                     (float(foF2_Gibi) - float(line_Gibi[8:12]))**2
        temporary_delta_foF2 = temporary_delta_foF2/2
        
        if temporary_delta_foF2 < delta_foF2:
            delta_foF2 = temporary_delta_foF2
            effective_index_foF2 = line_Rome[0:3] #here we could have written also line_Gibi[0:3]
        
    #print effective_index_foF2
        
    foF2_forecasted_file_Rome.close()
    foF2_forecasted_file_Gibi.close()
    shutil.copy(path_maps_foF2 + "f2" + processing_month_string + ".Maps/" + \
                  "f2" + processing_month_string + effective_index_foF2 + ".Maps/" + \
                  processing_month + processing_hour + effective_index_foF2 + ".gif", \
                  path_web_space_GIFINT + "current_foF2.gif")

#***************************
# END procedure foF2 map
#***************************
