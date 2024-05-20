<<<<<<< HEAD
# **eSWua Web-Service API documentation (V. 1.1.3)**


## **INDEX**

  - [Introduction](#introduction)
  - [eSWua scintillation database](#eswua-scintillation-database)
  - [Web service basic requests](#web-service-basic-requests)
  - [Matlab and Python examples](#matlab-and-python-examples)
  - [List of returned errors](#list-of-returned-errors)
  - [Contacts](#contacts)

## **Introduction**
=======
# eSWua Web-Service API documentation (V. 1.1.3)


## INDEX

1. [Introduction](#introduction)
1. [eSWua scintillation database](#eswua-scintillation-database)
1. [Web service basic requests](#web-service-basic-requests)
1. [Important notes](#important-notes)
1. [Matlab and Python examples](#matlab-and-python-examples)
1. [List of returned errors](#list-of-returned-errors)
1. [Contacts](#contacts)

## Introduction
>>>>>>> master

The eSWua RESTful Web service is based on the [PHP-CRUD-API project](https://github.com/mevdschee/php-crud-api).

The requests return JSON objects with the desired data set.

<<<<<<< HEAD
**DATA DOWNLOAD LIMIT**: the downloads are limited to a certain number of record per time; **the maximum temporal coverage for each request is in the order of 24 hour (temporal requests covering more than 1 day data will be rejected)**.
=======
**DATA DOWNLOAD LIMIT**: the downloads are limited to a certain number of record per time; the maximum temporal coverage for each request is in the order of 24 hour (temporal requests covering more than 1 day data will be rejected).
>>>>>>> master

Web service endpoint: http://ws-eswua.rm.ingv.it/


<<<<<<< HEAD
## **eSWua scintillation database**
=======
## eSWua scintillation database
>>>>>>> master

The following tables of the eSWua Scintillation database are accessible by the web service:

| wsstation  
| wsdmc0p  
| wsdmc0s  
| wsdmc1s  
| wsdmc2s  
| wskil0n  
| wslam0p  
| wslyb0p  
| wsmzs0p  
| wsnya0p  
| wsnya0s  
| wsnya1s  
| wssan0p  
| wssao0p

The table **wsstation** contains the list of all the INGV scintillation instrument and it has the following fields:

| id  
| code  
| filecode  
| name  
| lat  
| lon  
| h  
| area  
| description  
| fk_instrument  
| modified  
| instrument  

<<<<<<< HEAD
The following tables contains the data for different GNSS scintillation receivers:
=======
The following tables contains the data for the different scintillation instruments:
>>>>>>> master

-   **Septentrio PolaRx5S/PolaRxS**:  
    
<<<<<<< HEAD
    Tables/instrument code: **wsdmc0p, wslam0p, wslyb0p, wsmzs0p, wsnya0p, wssan0p, wssao0p**  
    
    Fields/parameters of each table:
    
    FIELD ----> DESCRIPTION  
    dt    ----> measure time UTC  
    svid  ----> satellite id number  
    rxstate  ----> Value of the RxState field of the ReceiverStatus SBF block  
    azimuth ----> SV Azimuth     
    elevation ----> SV Elevation         
    averagel1  ----> C/N 0: Average Sig1 C/N0 over the last minute (dB-Hz)    
    totals4l1  ----> Total S4 on Sig1 (dimensionless)   
    corrections4l1  ----> Correction to total S4 on Sig1 (thermal noise component only)(dimensionless)    
    phi01l1  ----> Phi01 on Sig1, 1-second phase sigma (radians)   
    phi03l1  ----> Phi03 on Sig1, 3-second phase sigma (radians)    
    phi10l1  ----> Phi10 on Sig1, 10-second phase sigma (radians)       
    phi30l1  ----> Phi30 on Sig1, 30-second phase sigma (radians)        
    phi60l1slant ----> Phi60 on Sig1, 60-second phase sigma (radians)        
    avgccdl1  ----> AvgCCD on Sig1, average of code/carrier divergence (meters)   
    sigmaccdl1   ----> SigmaCCD on Sig1, standard deviation of code/carrier divergence(meters)   
    tec45  ----> TEC at TOW - 45 seconds (TECU)   
    dtec60_45  ----> dTEC from TOW - 60s to TOW - 45s (TECU)    
    tec30  ----> TEC at TOW - 30 seconds (TECU)       
    dtec45_30  ----> dTEC from TOW - 45s to TOW - 30s (TECU)   
    tec15  ----> TEC at TOW - 15 seconds (TECU)   
    dtec30_15  ----> dTEC from TOW - 30s to TOW - 15s (TECU)    
    tec0  ----> TEC at TOW (TECU)     
    dtec0  ----> dTEC from TOW - 15s to TOW (TECU)  
    locktimel1  ----> Lock time on the second frequency used for the TEC computation(seconds)      
    reserved ----> sbf2ismr version number   
    2ndlocktime  ----> Lock time on the second frequency used for the TEC computation(seconds)    
    avgcn2freqtec  ----> Averaged C/N0 of second frequency used for the TEC computation (dB-Hz)      
    si\_l1\_29 ----> SI Index on Sig1:(10*log10(Pmax)-10*log10(Pmin))/(10*log10(Pmax)+10*log10(Pmin))(dimensionless)    
    si\_l1\_30  ----> SI Index on Sig1, numerator only: 10*log10(Pmax)-10*log10(Pmin) (dB)    
    pl1  ----> p on Sig1, spectral slope of detrended phase in the 0.1 to 25Hz range (dimensionless)     
    avg\_c\_n0_l2c  ---->  Average Sig2 C/N0 over the last minute (dB-Hz)            
    totals4_l2c ---->  Total S4 on Sig2 (dimensionless)    
    correctionS4_L2C  ----> Correction to total S4 on Sig2 (thermal noise component only) (dimensionless)   
    phi01_l2c   ----> Phi01 on Sig2, 1-second phase sigma (radians)  
    phi03_l2c    ----> Phi03 on Sig2, 3-second phase sigma (radians)    
    phi10_l2c    ----> Phi010 on Sig2, 10-second phase sigma (radians)    
    phi30_l2c    ----> Phi30 on Sig2, 30-second phase sigma (radians)    
    phi60_l2c    ----> Phi60 on Sig2, 60-second phase sigma (radians)    
    avgccd_l2c  ---->  AvgCCD on Sig2, average of code/carrier divergence (meters)      
    sigmaccd_l2c  ----> SigmaCCD on Sig2, standard deviation of code/carrier divergence (meters)  
    locktime_l2c  ----> Sig2 lock time (seconds)    
    si\_l2c\_43   ----> SI Index on Sig2 (dimensionless)     
    si\_l2c\_44    ----> SI Index on Sig2, numerator only (dB)  
    p_l2c  ----> p on Sig2, phase spectral slope in the 0.1 to 25Hz range (dimensionless)    
    avg\_c\_n0_l5 ---->  Average Sig3 C/N0 over the last minute (dB-Hz)    
    totals4_l5   ----> Total S4 on Sig3 (dimensionless)  
    corrections4_l5 ----> Correction to total S4 on Sig3 (thermal noise component only) (dimensionless)           
    phi01_l5  ----> Phi01 on Sig3, 1-second phase sigma (radians)       
    phi03_l5  ----> Phi03 on Sig3, 3-second phase sigma (radians)    
    phi10_l5  ----> Phi10 on Sig3, 10-second phase sigma (radians)    
    phi30_l5   ----> Phi30 on Sig3, 30-second phase sigma (radians)   
    phi60_l5    ----> Phi60 on Sig3, 60-second phase sigma (radians)  
    avgccd_l5     ----> AvgCCD on Sig3, average of code/carrier divergence (meters)   
    sigmaccd_l5     ----> SigmaCCD on Sig3, standard deviation of code/carrier divergence(meters)  
    locktime_l5     ----> Sig3 lock time (seconds)   
    si\_l5\_57    ----> SI Index on Sig3 (dimensionless)  
    si\_l5\_58  ----> SI Index on Sig3, numerator only (dB)     
    p_l5 ---->  p on Sig3, phase spectral slope in the 0.1 to 25Hz range (dimensionless)    
    t_l1   ---->  T on Sig1, phase power spectral density at 1 Hz (rad^2/Hz)    
    t_l2c   ---->  T on Sig2, phase power spectral density at 1 Hz (rad^2/Hz)     
    t_l5  ---->  T on Sig3, phase power spectral density at 1 Hz (rad^2/Hz)    
    fk_file  ---->  reference to file table   
    modified  ---->  Last Review     
    ipp_lat  
    ipp_lon  
    s4_l1_vert  
    phi60_l1_vert  
    stec  
    vtec  
    s4_l1_slant  
    s4_l2_vert  
    phi60_l2_vert  
    s4_l2_slant  
    phi60_l5_vert  
    s4_l5_slant  

    
-   **NovAtel GSV4004**:  
    
    Tables/instrument code: **wsdmc0s, wsdmc1s, wsdmc2s, wsnya0s, wsnya1s**  
   
    Fields/parameters of each table:
    
    FIELD ----> DESCRIPTION  
	dt  ----> measure time UTC  
    svid  ----> satellite id number  
    rxstate  ----> Value of the RxState field of the ReceiverStatus SBF block  
    azimuth  ----> SV Azimuth   
    elevation ----> SV Elevation   
    averagel1  ----> C/N 0: Average Sig1 C/N0 over the last minute (dB-Hz)  
    totals4l1  ----> Total S4 on Sig1 (dimensionless)  
    corrections4l1  ----> Correction to total S4 on Sig1 (thermal noise component only)(dimensionless)  
    phi01l1  ----> Phi01 on Sig1, 1-second phase sigma (radians)   
    phi03l1  ----> Phi03 on Sig1, 3-second phase sigma (radians)    
    phi10l1  ----> Phi10 on Sig1, 10-second phase sigma (radians)       
    phi30l1  ----> Phi30 on Sig1, 30-second phase sigma (radians)        
    phi60l1slant ----> Phi60 on Sig1, 60-second phase sigma (radians)        
    avgccdl1  ----> AvgCCD on Sig1, average of code/carrier divergence (meters)  
    sigmaccdl1  ----> SigmaCCD on Sig1, standard deviation of code/carrier divergence(meters)  
    tec45  ----> TEC at TOW - 45 seconds (TECU)   
    dtec60_45  ----> dTEC from TOW - 60s to TOW - 45s (TECU)    
    tec30  ----> TEC at TOW - 30 seconds (TECU)       
    dtec45_30  ----> dTEC from TOW - 45s to TOW - 30s (TECU)   
    tec15  ----> TEC at TOW - 15 seconds (TECU)   
    dtec30_15  ----> dTEC from TOW - 30s to TOW - 15s (TECU)    
    tec0  ----> TEC at TOW (TECU)     
    dtec0  ----> dTEC from TOW - 15s to TOW (TECU)  
    locktimel1  ----> Lock time on the second frequency used for the TEC computation(seconds)           
    chanstatus  ----> Channel status  
    2ndlocktime  ----> Lock time on the second frequency used for the TEC computation(seconds)       
    avgcn2freqtec  ----> Averaged C/N0 of second frequency used for the TEC computation (dB-Hz)    
    fk_file  ----> reference to file table  
    modified  ----> Last Review  
    ipp_lat  
    ipp_lon  
    s4_l1_vert  
    phi60_l1_vert  
    stec  
    vtec  
    s4_l1_slant  


-   **NovAtel GPStation-6**:  
    
    Table/instrument code: **wskil0n**  
    
    Fields/parameters of each table:
    
    FIELD ----> DESCRIPTION  
    dt    ----> measure time UTC    
    svid  ----> satellite id number    
    azimuth  ----> SV Azimuth   
    elevation ----> SV Elevation     
    averagel1  ----> C/N 0: Average Sig1 C/N0 over the last minute (dB-Hz)    
    totals4l1  ----> Total S4 on Sig1 (dimensionless)   
    corrections4l1  ----> Correction to total S4 on Sig1 (thermal noise component only)(dimensionless)    
    phi01l1  ----> Phi01 on Sig1, 1-second phase sigma (radians)   
    phi03l1  ----> Phi03 on Sig1, 3-second phase sigma (radians)    
    phi10l1  ----> Phi10 on Sig1, 10-second phase sigma (radians)       
    phi30l1  ----> Phi30 on Sig1, 30-second phase sigma (radians)        
    phi60l1slant ----> Phi60 on Sig1, 60-second phase sigma (radians)        
    avgccdl1  ----> AvgCCD on Sig1, average of code/carrier divergence (meters)   
    sigmaccdl1   ----> SigmaCCD on Sig1, standard deviation of code/carrier divergence(meters)   
    tec45  ----> TEC at TOW - 45 seconds (TECU)   
    dtec60_45  ----> dTEC from TOW - 60s to TOW - 45s (TECU)    
    tec30  ----> TEC at TOW - 30 seconds (TECU)       
    dtec45_30  ----> dTEC from TOW - 45s to TOW - 30s (TECU)   
    tec15  ----> TEC at TOW - 15 seconds (TECU)   
    dtec30_15  ----> dTEC from TOW - 30s to TOW - 15s (TECU)    
    tec0  ----> TEC at TOW (TECU)     
    dtec0  ----> dTEC from TOW - 15s to TOW (TECU)  
    locktimel1  ----> Lock time on the second frequency used for the TEC computation(seconds)      
    avg\_c\_n0_l2c  ---->  Average Sig2 C/N0 over the last minute (dB-Hz)            
    totals4_l2c ---->  Total S4 on Sig2 (dimensionless)    
    correctionS4_L2C  ----> Correction to total S4 on Sig2 (thermal noise component only) (dimensionless)   
    phi01_l2c   ----> Phi01 on Sig2, 1-second phase sigma (radians)  
    phi03_l2c    ----> Phi03 on Sig2, 3-second phase sigma (radians)    
    phi10_l2c    ----> Phi010 on Sig2, 10-second phase sigma (radians)    
    phi30_l2c    ----> Phi30 on Sig2, 30-second phase sigma (radians)    
    phi60_l2c    ----> Phi60 on Sig2, 60-second phase sigma (radians)    
    avgccd_l2c  ---->  AvgCCD on Sig2, average of code/carrier divergence (meters)      
    sigmaccd_l2c  ----> SigmaCCD on Sig2, standard deviation of code/carrier divergence (meters)  
    locktime_l2c  ----> Sig2 lock time (seconds)    
    avg\_c\_n0_l5 ---->  Average Sig3 C/N0 over the last minute (dB-Hz)    
    totals4_l5   ----> Total S4 on Sig3 (dimensionless)  
    corrections4_l5 ----> Correction to total S4 on Sig3 (thermal noise component only) (dimensionless)           
    phi01_l5  ----> Phi01 on Sig3, 1-second phase sigma (radians)       
    phi03_l5  ----> Phi03 on Sig3, 3-second phase sigma (radians)    
    phi10_l5  ----> Phi10 on Sig3, 10-second phase sigma (radians)    
    phi30_l5   ----> Phi30 on Sig3, 30-second phase sigma (radians)   
    phi60_l5    ----> Phi60 on Sig3, 60-second phase sigma (radians)  
    avgccd_l5     ----> AvgCCD on Sig3, average of code/carrier divergence (meters)   
    sigmaccd_l5     ----> SigmaCCD on Sig3, standard deviation of code/carrier divergence(meters)  
    locktime_l5     ----> Sig3 lock time (seconds)   
    tec45_2c ---->  TEC at TOW - 45 seconds (TECU)      
    dtec60\_45\_2c ---->   dTEC from TOW - 60s to TOW - 45s (TECU)   
    tec30_2c  ---->   TEC at TOW - 30 seconds (TECU)    
    dtec45\_30\_2c ---->   dTEC from TOW - 45s to TOW - 30s (TECU)    
    tec15_2c ---->   TEC at TOW - 15 seconds (TECU)     
    dtec30\_15\_2c ---->   dTEC from TOW - 30s to TOW - 15s (TECU)    
    tec0_2c ---->  TEC at TOW (TECU)    
    dtec0_2c ---->   dTEC from TOW - 15s to TOW (TECU)    
    fk_file ---->  reference to file table   
    modified ---->  Last Review  
    ipp_lat  
    ipp_lon  
    s4_l1_vert  
    phi60_l1_vert  
    stec  
    vtec  
    s4_l1_slant  
    s4_l2_vert  
    phi60_l2_vert  
    s4_l2_slant  
    phi60_l5_vert  
    s4_l5_slant  
    
## **Web service basic requests**

**Starting index to access data**: http://ws-eswua.rm.ingv.it/scintillation.php/records/

-   **ACCESS TO SINGLE TABLE** 
    
    General rule:  
    http://ws-eswua.rm.ingv.it/scintillation.php/records/ **table_name**  
    where **table_name** has to be replaced with the desired table of the scintillation database. It returns all the fields present in that table.
    
    > **Example**:  
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation)  
    > returns the list of all the scintillation instruments and the related fields

-   **ACCESS TO SINGLE/MULTIPLE FIELD OF A TABLE**

    By default all fields are selected. With the **include** parameter you can select specific fields. You may use a dot to separate the table name from the field name. Multiple fields should be comma separated. An asterisk (*) may be used as a wildcard to indicate **all fields**. Similar to **include** you may use the **exclude** parameter to remove certain fields.
    
    General rule:  
    http://ws-eswua.rm.ingv.it/scintillation.php/records/ **table_name** /?include= **field_name1,field_name2,etc**  
    where **field_name** has to be replaced with the desired fields.
    
=======
    Tables: 

    **wsdmc0p, wslam0p, wslyb0p, wsmzs0p, wsnya0p, wssan0p, wssao0p**  
    
    Fields/parameters of each table:
    
    | dt  
    | svid  
    | rxstate  
    | azimuth  
    | elevation  
    | averagel1  
    | totals4l1  
    | corrections4l1  
    | phi01l1  
    | phi03l1  
    | phi10l1  
    | phi30l1  
    | phi60l1slant  
    | avgccdl1  
    | sigmaccdl1  
    | tec45  
    | dtec60_45  
    | tec30  
    | dtec45_30  
    | tec15  
    | dtec30_15  
    | tec0  
    | dtec0  
    | locktimel1  
    | reserved  
    | 2ndlocktime  
    | avgcn2freqtec  
    | si\_l1\_29  
    | si\_l1\_30  
    | pl1  
    | avg\_c\_n0_l2c  
    | totals4_l2c  
    | correctionS4_L2C  
    | phi01_l2c  
    | phi03_l2c  
    | phi10_l2c  
    | phi30_l2c  
    | phi60_l2c  
    | avgccd_l2c  
    | sigmaccd_l2c  
    | locktime_l2c  
    | si\_l2c\_43  
    | si\_l2c\_44  
    | p_l2c  
    | avg\_c\_n0_l5  
    | totals4_l5  
    | corrections4_l5  
    | phi01_l5  
    | phi03_l5  
    | phi10_l5  
    | phi30_l5  
    | phi60_l5  
    | avgccd_l5  
    | sigmaccd_l5  
    | locktime_l5  
    | si\_l5\_57  
    | si\_l5\_58  
    | p_l5  
    | t_l1  
    | t_l2c  
    | t_l5  
    | fk_file  
    | modified  
    | ipp_lat  
    | ipp_lon  
    | s4_l1_vert  
    | phi60_l1_vert  
    | stec  
    | vtec  
    | s4_l1_slant  
    | s4_l2_vert  
    | phi60_l2_vert  
    | s4_l2_slant  
    | phi60_l5_vert  
    | s4_l5_slant  

  
-   **Novatel GPS Instrument**:  
    
    Tables:

     **wsdmc0s, wsdmc1s, wsdmc2s, wsnya0s, wsnya1s**  
   
    Fields/parameters of each table:
    
	| dt  
    | svid  
    | rxstate  
    | azimuth  
    | elevation  
    | averagel1  
    | totals4l1  
    | corrections4l1  
    | phi01l1  
    | phi03l1  
    | phi10l1  
    | phi30l1  
    | phi60l1slant  
    | avgccdl1  
    | sigmaccdl1  
    | tec45  
    | dtec60_45  
    | tec30  
    | dtec45_30  
    | tec15  
    | dtec30_15  
    | tec0  
    | dtec0  
    | locktimel1  
    | chanstatus  
    | 2ndlocktime  
    | avgcn2freqtec  
    | fk_file  
    | modified  
    | ipp_lat  
    | ipp_lon  
    | s4_l1_vert  
    | phi60_l1_vert  
    | stec  
    | vtec  
    | s4_l1_slant  


-   **Novatel multi-constellation Instrument**:  
    
    Table:

    **wskil0n**  
    
    Fields/parameters of each table:
    
    | dt  
    | svid  
    | azimuth  
    | elevation  
    | averagel1  
    | totals4l1  
    | corrections4l1  
    | phi01l1  
    | phi03l1  
    | phi10l1  
    | phi30l1  
    | phi60l1slant  
    | avgccdl1  
    | sigmaccdl1  
    | tec45  
    | dtec60_45  
    | tec30  
    | dtec45_30  
    | tec15  
    | dtec30_15  
    | tec0  
    | dtec0  
    | locktimel1  
    | avg\_c\_n0_l2c  
    | totals4_l2c  
    | correctionS4_L2C  
    | phi01_l2c  
    | phi03_l2c  
    | phi10_l2c  
    | phi30_l2c  
    | phi60_l2c  
    | avgccd_l2c  
    | sigmaccd_l2c  
    | locktime_l2c  
    | avg\_c\_n0_l5  
    | totals4_l5  
    | corrections4_l5  
    | phi01_l5  
    | phi03_l5  
    | phi10_l5  
    | phi30_l5  
    | phi60_l5  
    | avgccd_l5  
    | sigmaccd_l5  
    | locktime_l5  
    | tec45_2c  
    | dtec60\_45\_2c  
    | tec30_2c  
    | dtec45\_30\_2c  
    | tec15_2c  
    | dtec30\_15\_2c  
    | tec0_2c  
    | dtec0_2c  
    | fk_file  
    | modified
    | ipp_lat  
    | ipp_lon  
    | s4_l1_vert  
    | phi60_l1_vert  
    | stec  
    | vtec  
    | s4_l1_slant  
    | s4_l2_vert  
    | phi60_l2_vert  
    | s4_l2_slant  
    | phi60_l5_vert  
    | s4_l5_slant  
    
## Web service basic requests

**Starting index to access data**: http://ws-eswua.rm.ingv.it/scintillation.php/records/

-   **ACCESS TO SINGLE TABLE** 
    
    General rule:  
    http://ws-eswua.rm.ingv.it/scintillation.php/records/ **table_name**  
    where **table_name** has to be replaced with the desired table of the scintillation database. It returns all the fields present in that table.
    
    > **Example**:  
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation)  
    > returns the list of all the scintillation instruments and the related fields

-   **ACCESS TO SINGLE/MULTIPLE FIELD OF A TABLE**

    By default all fields are selected. With the **include** parameter you can select specific fields. You may use a dot to separate the table name from the field name. Multiple fields should be comma separated. An asterisk (*) may be used as a wildcard to indicate **all fields**. Similar to **include** you may use the **exclude** parameter to remove certain fields.
    
    General rule:  
    http://ws-eswua.rm.ingv.it/scintillation.php/records/ **table_name** /?include= **field_name1,field_name2,etc**  
    where **field_name** has to be replaced with the desired fields.
    
>>>>>>> master
    > **Example1**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?include=code](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?include=code)  
    > returns the field **code** (instrument code) for all the records of the table **wsstation**
    > 
    > **Example2**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?include=lat,lon](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?include=lat,lon)  
    > returns the **lat** (latitude) adn **lon** (longitude) field for all the records of the table **wsstation**.

-   **ORDER THE RESULTS**
    
    With the **order** string you can sort the results. By default the sort is in ascending order, but by specifying **desc** this can be reversed:

    > **Example1**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?include=code,id&order=code](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?include=code,id&order=code)  
    > the station list (id and code field) will be order by **code** field
    > 
    > **Example2**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?include=code,id&order=id,desc](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?include=code,id&order=id,desc)  
    > the station list (id and code field) will be order (descending) by **id** field

-   **LIMIT THE NUMBER OF THE RETURNED RECORDS**
    
    The **size** string limits the number of the returned records.

    > **Example1**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?size=3](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?size=3)  
    > limits the returned records from table **wsstation** to 3

-   **APPLY FILTERS AND MULTIPLE CONDITIONS TO THE REQUESTS**
    
    Filters provide search functionality, on list calls, using the filter parameters. You need to specify the field name, a comma, the match type, another comma and the value you want to filter on. These are supported match types:
    
    -   **cs**: contain string (string contains value)
    -   **sw**: start with (string starts with value)
    -   **ew**: end with (string end with value)
    -   **eq**: equal (string or number matches exactly)
    -   **lt**: lower than (number is lower than value)
    -   **le**: lower or equal (number is lower than or equal to value)
    -   **ge**: greater or equal (number is higher than or equal to value)
    -   **gt**: greater than (number is higher than value)
    -   **bt**: between (number is between two comma separated values)
    -   **in**: in (number or string is in comma separated list of values)
    -   **is**: is null (field contains NULL value)

    > **Example1**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?filter=code,eq,dmc0p](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?filter=code,eq,dmc0p)  
    > returns only the station where the code is **dmc0p**
    > 
    > **Example2**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsdmc0p?filter=dt,bt,2019-10-16 02:45:00,2019-10-16 03:00:00&order=dt](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsdmc0p?filter=dt,bt,2019-10-16%2002:45:00,2019-10-16%2003:00:00&order=dt)  
    > returns all the fields of the table **wsdmc0p** (dmc0p septentrio instrument) for the time period between **2019-10-16 02:45:00** and **2019-10-16 03:00:00** ordered by time
    > 
    > **Example3**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wslyb0p?filter=dt,bt,2019-10-16 02:45:00,2019-10-16 03:00:00&order=dt&include=svid](http://ws-eswua.rm.ingv.it/scintillation.php/records/wslyb0p?filter=dt,bt,2019-10-16%2002:45:00,2019-10-16%2003:00:00&order=dt&include=svid)  
    > returns only the field **svid** for the table **wslyb0p** (lyb0p septentrio instrument) for the time period between **2019-10-16 02:45:00** and **2019-10-16 03:00:00** ordered by time
    
<<<<<<< HEAD
    ## **Important notes**
=======
    ## Important notes
>>>>>>> master

1.  **DATA DOWNLOAD LIMIT**: the downloads are limited to a certain number of record per time; the maximum temporal coverage for each request is in the order of 24 hour (temporal requests covering more than 1 day data will be rejected).
   
2.  The field **dt** of contains the time in which the measurements are recorded and is in the format: **YY-MM-DD hh-mm-ss**
  
3.  The blank space in the **dt** field between **DD** and **hh** must to be substituted with a **%20** in a temporal filtered request

    > **Example**: if the chosen **dt** is: **2019-10-16 02:45:00** the string must be included as **2019-10-16%2002:45:00**.
 
4.  If you want to apply multiple filters and conditions as an **AND** operator you need to use the **&** concatenator

    > **Example**: 
    > [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?filter=area,eq,ANTARCTIC&filter=code,sw,dmc](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?filter=area,eq,ANTARCTIC&filter=code,sw,dmc)  
    > returns the stations located in the ANTARCTIC wich names starts with **dmc**
  
5.  If you want to apply multiple filters and conditions as an **OR** operator you need to enumerate the different filters
<<<<<<< HEAD

    > **Example**: [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?filter1=area,eq,ANTARCTIC&filter2=area,eq,ARCTIC](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?filter1=area,eq,ANTARCTIC&filter2=area,eq,ARCTIC)  
    > returns the stations located in the ANTARCTIC and the ARCTIC area


## **Matlab and Python examples**
=======

    > **Example**: [http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?filter1=area,eq,ANTARCTIC&filter2=area,eq,ARCTIC](http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation?filter1=area,eq,ANTARCTIC&filter2=area,eq,ARCTIC)  
    > returns the stations located in the ANTARCTIC and the ARCTIC area

## Matlab and Python examples
>>>>>>> master

> **MATLAB Example**

```
<<<<<<< HEAD
%% Matlab code for retrieve all the fields/parameters from the last temporal record recorded in the database
=======
%% Matlab code for retrieve all the fields/parameters from the last registered temporal record for a specific station 
>>>>>>> master

clc
close all
clear all

%retrieve the scintillation stations/instruments list
stations='http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation';
station_list=cell2mat(struct2cell(webread(stations))); %%structure with the stations/instruments list

%% retrieve the complete set of parameters in the last available time instant

station='lyb0p'; %change the station code for retrieve the parameters from other stations

%identification of the last available record
time_limit=sprintf('http://ws-eswua.rm.ingv.it/scintillation.php/records/ws%s?include=dt&order=dt,desc&size=1',station);
time=webread(time_limit); %last available temporal instant
%retireve the parameters
parameter_link=sprintf('http://ws-eswua.rm.ingv.it/scintillation.php/records/ws%s?filter=dt,eq,%s&order=dt',station,time.records.dt);
parameter_list=webread(parameter_link);
parameter=cell2mat(struct2cell(parameter_list)); %struct with the parameters for the chosen instrument

```

> **Python Example**

```
<<<<<<< HEAD
### Python code for retrieve all the fields/parameters from the last temporal record recorded in the database
=======
### Python code for retrieve all the fields/parameters from the last registered temporal record for a specific station
>>>>>>> master

import json
import urllib.request

#retrieve the scintillation stations/instruments list
url='http://ws-eswua.rm.ingv.it/scintillation.php/records/wsstation'
webURL=urllib.request.urlopen(url)
station_list=json.loads(webURL.read())  # station_list is a dictionary with the stations/instruments list

#Retrieve the complete set of parameters in the last available time instant ####

station='lyb0p'  #change the station code for retrieve the parameters from other stations

#identification of the last available record
url =  'http://ws-eswua.rm.ingv.it/scintillation.php/records/ws{}?include=dt&order=dt,desc&size=1'.format(station)
webURL=urllib.request.urlopen(url)
data=json.loads(webURL.read())
time=data["records"][0]["dt"] #last available record

#retireve the parameters
time=time.replace(" ","%20") #blank spaces needs substitution with "%20"
url='http://ws-eswua.rm.ingv.it/scintillation.php/records/ws{}?filter=dt,eq,{}&order=time'.format(station,time)
webURL=urllib.request.urlopen(url)
parameter=json.loads(webURL.read()) # parameter is a dictionary with the stations/instruments list
print(parameter) #print of the parameters

```

<<<<<<< HEAD
## **List of returned errors**
=======
## List of returned errors
>>>>>>> master

The following errors may be reported:

**Error / HTTPresponse code / Message:**  
1000 / 404 Not found / Route not found  
1001 / 404 Not found / Table not found  
1002 / 422 Unprocessable entity / Argument count mismatch  
1003 / 404 Not found / Record not found  
1004 / 403 Forbidden / Origin is forbidden  
1005 / 404 Not found / Column not found  
1006 / 409 Conflict / Table already exists  
1007 / 409 Conflict / Column already exists  
1008 / 422 Unprocessable entity / Cannot read HTTP message  
1009 / 409 Conflict / Duplicate key exception  
1010 / 409 Conflict / Data integrity violation  
1011 / 401 Unauthorized / Authentication required  
1012 / 403 Forbidden / Authentication failed  
1013 / 422 Unprocessable entity / Input validation failed  
1014 / 403 Forbidden / Operation forbidden  
1015 / 405 Method not allowed / Operation not supported  
1016 / 403 Forbidden / Temporary or permanently blocked  
1017 / 403 Forbidden / Bad or missing XSRF token  
1018 / 403 Forbidden / Only AJAX requests allowed  
1019 / 403 Forbidden / Pagination Forbidden  
9999 / 500 Internal server error / Unknown error

<<<<<<< HEAD
## **Contacts**
=======
## Contacts
>>>>>>> master

Emanuele Pica: [emanuele.pica@ingv.it](mailto:emanuele.pica@ingv.it)  
Carlo Marcocci: [carlo.marcocci@ingv.it](mailto:carlo.marcocci@ingv.it)  
Claudio Cesaroni: [claudio.cesaroni@ingv.it](mailto:claudio.cesaroni@ingv.it)
