import os
import json
#------------------------    CREAZIONE FUNZIONE DI LETTURA     ------------------------------------------------------
# la funzione accetta come argomento il numero il numero di elementi da leggere
# e il numero di cifre (punto '.' compreso) da cui è formato ogni elemento (es. 9999.000 -> 8; 0.293805E+3 -> 11)  
# restituisce una unica stringa con il risultato della lettura compresi i caratteri '\n'

def lettura_righe(elementi,cifre):      #elementi è un intero il numero di elementi 
                                        #cifre è  (es. 9999.000-> 8; 0.293805E+3-> 11)

    if ((elementi*cifre)%120)>0:        #controllo che quello che devo leggere sia o no un multiplo esatto di 120
        righe= (elementi*cifre)//120+1
    else:
        righe=(elementi*cifre)//120

    stringa_appo=''                     
    for indice in range(0,righe):
        stringa_appo=stringa_appo+f.readline()
    return stringa_appo
#---------------------------------------------------------------------------------------------------------

#--------   elenco cartelle utili per le operazioni di lettura e scrittura     --------------------
current_dir=os.getcwd()         #nella dir corrente c'è il codice python
SAO_dir=current_dir+'\SAO'      #qui ci sono i SAO file da processare (vengono cancellati alla fine del processo)
TXT_dir=current_dir+'\TXT'      #qui c'è il risultato in formato ASCII colonnare
DONE_dir=current_dir+'\DONE'    #qui ci sono i SAO file processati
JSON_dir=current_dir+'\JSON'    #qui c'è il risultato in formato JSON
#-------------------------------------------------------------------------------------------------#

files_list=os.listdir(SAO_dir)  #lista che contiene l'elenco dei nomi dei SAO iniziali
 
for file in files_list:
    groups_content=[]           #lista di stringhe, una per gruppo, ognuna delle quali conterrà gli elementi del gruppo
    groups_content.append('')   #inizializzo l'elemento zero (in tal modo i gruppi corrisponderanno agli indici 1 - 80)

    gruppi=[]                   #lista di numeri, uno per gruppo, corrispondenti al numero di elementi del gruppo
    gruppi.append('')           #inizializzo l'elemento zero (i gruppi corrisponderanno agli indici 1 - 80)
    
    f=open(SAO_dir+'\\'+file,'r')       #

    linea1=lettura_righe(40,3)                     #leggo la prima riga del file (gruppi 1 - 40)
    linea2=lettura_righe(40,3)                     #leggo la seconda riga del file (gruppi 41 - 80)


 #   print(linea1,'\n',linea2)
    #print(len(linea1))

    #----------------  riempimento della lista "gruppi" che contiene il numero di elementi di ciascun gruppo   ----
    for indice in range(0,40):
        gruppi.append(int(linea1[3*indice:3*indice+3]))  #riempio lista 'gruppi' con numeri
                                                    
    for indice in range(0,40):
        gruppi.append(int(linea2[3*indice:3*indice+3]))  #riempio lista 'gruppi' con numeri
                                                    
    #----------------- fine funzione riempimento lista "gruppi"    -----------------------------------------------

    #legge le righe del file secondo il numero di elementi e formattazione e le memorizza in "groups_content"
    #ogni gruppo sarà descritto da una stringa. I gruppi vuoti sono descritti dalla stringa vuota ''

    for indice in range(1,80):
        if gruppi[indice]!=0:
            if (indice==1 or indice==6):
                groups_content.append(lettura_righe(gruppi[indice],7))

            elif (indice==2):
                groups_content.append(lettura_righe(gruppi[indice],120))
                
            elif (indice==3 or indice==10 or indice==15):
                groups_content.append(lettura_righe(gruppi[indice],1))
            elif (indice==20 or indice==24 or indice==28 or indice==32 or indice==55):
                groups_content.append(lettura_righe(gruppi[indice],1))
            elif (indice==41 or indice==45 or indice==49 or indice==54 or indice==56):
                groups_content.append(lettura_righe(gruppi[indice],1))

            elif (indice==5):
                groups_content.append(lettura_righe(gruppi[indice],2))

            elif (indice==9 or indice==14 or indice==19 or indice==23 or indice==27):
                groups_content.append(lettura_righe(gruppi[indice],3))
            elif (indice==31 or indice==34 or indice==35):
                groups_content.append(lettura_righe(gruppi[indice],3))
            elif (indice==36 or indice==44 or indice==48):
                groups_content.append(lettura_righe(gruppi[indice],3))    

            elif (indice==4 or indice==7 or indice==8 or indice==11 or indice==12):
                groups_content.append(lettura_righe(gruppi[indice],8))
            elif (indice==13 or indice==16 or indice==17 or indice==18 or indice==21):
                groups_content.append(lettura_righe(gruppi[indice],8))
            elif (indice==22 or indice==25 or indice==26 or indice==29 or indice==30):
                groups_content.append(lettura_righe(gruppi[indice],8))
            elif (indice==33 or indice==43 or indice==46 or indice==47 or indice==50):
                groups_content.append(lettura_righe(gruppi[indice],8))
            elif (indice==51 or indice==52 or indice==53):
                groups_content.append(lettura_righe(gruppi[indice],8))

            elif (indice==37 or indice==38 or indice==39 or indice==42):
                groups_content.append(lettura_righe(gruppi[indice],11))

            elif (indice==40):
                groups_content.append(lettura_righe(gruppi[indice],20))    
        else:
            groups_content.append('') 

    f.close()


            


    #--------------  creazione liste srringhe dei gruppi che mi interessano o delle variabili   -------------------------
    #--------------   in questa fase vengono eliminati i caratteri di andata a capo         -----------------------------

    #gruppo 1 costanti geofisiche  sono memorizzate in una lista di stringhe      
    geophys_const=[]
    for indice in range(0,gruppi[1]):
        geophys_const.append((groups_content[1].replace('\n','')[7*indice:7*indice+7]))

    #gruppo 3 timestamp suddiviso in variabili string format
    year_str=groups_content[3][2:6]
    calendar_day_str=groups_content[3][6:9]
    month_str=groups_content[3][9:11]
    day_str=groups_content[3][11:13]
    hour_str=groups_content[3][13:15]
    minute_str=groups_content[3][15:17]
    second_str=groups_content[3][17:19]

    #gruppo 4 parametri ionosferici string format
    ionospheric_params=[]               #lista di stringhe che contiene i parametri ionosferici 
    for indice in range(0,gruppi[4]):
        ionospheric_params.append((groups_content[4].replace('\n','')[8*indice:8*indice+8]))

    #-----    da questo gruppo ricavo le seguenti caratteristiche ionosferiche in formato numero:
    foF2=float(ionospheric_params[0])
    if foF2==999.9 or foF2==9999.0:
        foF2=None

    foF1=float(ionospheric_params[1])
    if foF1==999.9 or foF1==9999.0:
        foF1=None

    M3000F2=float(ionospheric_params[2])
    if M3000F2==999.9 or M3000F2==9999.0:
        M3000F2=None

    MUF3000F2=float(ionospheric_params[3])
    if MUF3000F2==999.9 or MUF3000F2==9999.0:
        MUF3000F2=None
        
    fmin=float(ionospheric_params[4])
    if MUF3000F2==999.9 or MUF3000F2==9999.0:
        MUF3000F2=None
        
    foEs=float(ionospheric_params[5])
    if foEs==999.9 or foEs==9999.0:
        foEs=None
        
    foE=float(ionospheric_params[8])
    if foE==999.9 or foE==9999.0:
        foE=None
        
    fxI=float(ionospheric_params[9])
    if fxI==999.9 or fxI==9999.0:
        fxI=None
        
    h_F=float(ionospheric_params[10])
    if h_F==999.9 or h_F==9999.0:
        h_F=None
        
    h_F2=float(ionospheric_params[11])
    if h_F2==999.9 or h_F2==9999.0:
        h_F2=None
        
    h_E=float(ionospheric_params[12])
    if h_E==999.9 or h_E==9999.0:
        h_E=None
        
    h_Es=float(ionospheric_params[13])
    if h_Es==999.9 or h_Es==9999.0:
        h_Es=None

    if gruppi[4]>38:                         #lo leggo solo se il TEC è presente
        TEC=float(ionospheric_params[38])
    else:
        TEC=Null
    ##if gruppi[4]>48:                       #lo leggo solo se fbEs è presente
    ##    fbEs=ionospheric_params[47]          

#----------------   CREAZIONE LISTE PER TRACCIA RICOSTRUITA F2     ----------------------------------------------

    #gruppo 7 altezze virtuali strato F2 ricostruiti (km)
    F2_virtual_heights=[]                
    for indice in range(0,gruppi[7]):
        F2_virtual_heights.append(float((groups_content[7].replace('\n','')[8*indice:8*indice+8])))

    #gruppo 11 frequenze strato F2 ricostruiti (MHz)
    F2_frequencies=[]
    for indice in range(0,gruppi[11]):
        F2_frequencies.append(float((groups_content[11].replace('\n','')[8*indice:8*indice+8])))
#--------------------------------------------------------------------------------------------------------------------

#----------------   CREAZIONE LISTE PER TRACCIA RICOSTRUITA F1     ----------------------------------------------

    #gruppo 12 altezze virtuali strato F1 ricostruiti (km)
    F1_virtual_heights=[]
    for indice in range(0,gruppi[12]):
        F1_virtual_heights.append(float((groups_content[12].replace('\n','')[8*indice:8*indice+8])))

    #gruppo 16 frequenze strato F1 ricostruiti (MHz)
    F1_frequencies=[]
    for indice in range(0,gruppi[16]):
        F1_frequencies.append(float((groups_content[16].replace('\n','')[8*indice:8*indice+8])))

#--------------------------------------------------------------------------------------------------------------

#----------------   CREAZIONE LISTE PER TRACCIA RICOSTRUITA E     ----------------------------------------------
    
    #gruppo 17 altezze virtuali strato E ricostruiti (km)
    E_virtual_heights=[]
    for indice in range(0,gruppi[17]):
        E_virtual_heights.append(float((groups_content[17].replace('\n','')[8*indice:8*indice+8])))

    #gruppo 21 frequenze strato E ricostruiti (MHz)
    E_frequencies=[]
    for indice in range(0,gruppi[21]):
        E_frequencies.append(float((groups_content[21].replace('\n','')[8*indice:8*indice+8])))

#------------------------------------------------------------------------------------------------------------------

#----------------   CREAZIONE LISTE PER TRACCIA RICOSTRUITA Es     ----------------------------------------------
    #gruppo 43 altezze virtuali strato Es ricostruiti (km)
    Es_virtual_heights=[]
    for indice in range(0,gruppi[43]):
        Es_virtual_heights.append(float((groups_content[43].replace('\n','')[8*indice:8*indice+8])))

    #gruppo 46 frequenze strato Es ricostruiti (MHz)
    Es_frequencies=[]
    for indice in range(0,gruppi[46]):
        Es_frequencies.append(float((groups_content[46].replace('\n','')[8*indice:8*indice+8])))

#----------------------------------------------------------------------------------------------------------------

#----------------   CREAZIONE LISTE PER TRACCIA PROFILO DENSITà     ----------------------------------------------
    
    #gruppo 51 altezza reale densità elettronica (km)
    true_height=[]
    for indice in range(0,gruppi[51]):
        true_height.append(float((groups_content[51].replace('\n','')[8*indice:8*indice+8])))

    #gruppo 52 frequenze plasma (MHz)
    plasma_frequency=[]
    for indice in range(0,gruppi[52]):
        plasma_frequency.append(float((groups_content[52].replace('\n','')[8*indice:8*indice+8])))

# carlo
# non caricare perche ricavabile
    #gruppo 53 densità elettronica in (elettroni/cm3)ricostruiti
    electron_density=[]
    for indice in range(0,gruppi[53]):
        electron_density.append(float((groups_content[53].replace('\n','')[8*indice:8*indice+8])))
#-------------------------------------------------------------------------------------------------------------------
        
#-------     scrittura file ASCII formato colonnare con nome YYYY_MM_DD_hhmmss.txt     ----------------
    nome_file=year_str+'_'+month_str+'_'+day_str+'_'+hour_str+minute_str+second_str
    
    with open(TXT_dir+'\\'+nome_file+'.txt','w') as fout:   #scrivo i valori dopo averli trasformati in stringa
        fout.write(nome_file+'\n\n')
        fout.write('foF2= '+str(foF2)+'\n')
        fout.write('foF1= '+str(foF1)+'\n')
        fout.write('M3000F2= '+str(M3000F2)+'\n')
        fout.write('MUF3000F2= '+str(MUF3000F2)+'\n')
        fout.write('fmin= '+str(fmin)+'\n')
        fout.write('foEs= '+str(foEs)+'\n')
        fout.write('foE= '+str(foE)+'\n')
        fout.write('fxI= '+str(fxI)+'\n')
        fout.write("h'F= "+str(h_F)+'\n')
        fout.write("h'F2= "+str(h_F2)+'\n')
        fout.write("h'E= "+str(h_E)+'\n')
        fout.write("h'Es= "+str(h_Es)+'\n')
        fout.write("TEC= "+str(TEC)+'\n')
            
    ##    if gruppi[4]>48:
    ##        fout.write("fbEs= "+str(fbEs)+'\n')   
        
        fout.write('\nDENSITY_PROFILE\n')
        fout.write('\ntrue_heights\t\t\tplasma_freq\t\t\telectron_density\n')
        for indice in range(0,gruppi[51]):
            fout.write(str(true_height[indice])+'\t\t\t'+str(plasma_frequency[indice])+'\t\t\t'+str(electron_density[indice])+'\n')

        fout.write('\nF1_LAYER_RECONSTRUCTION\n')
        fout.write('\nvirtual_heights\t\t\tfrequency\n')
        for indice in range(0,gruppi[12]):
            fout.write(str(F1_virtual_heights[indice])+'\t\t\t'+str(F1_frequencies[indice])+'\n')

        fout.write('\nF2_LAYER_RECONSTRUCTION\n')
        fout.write('\nvirtual_heights\t\t\tfrequency\n')
        for indice in range(0,gruppi[7]):
            fout.write(str(F2_virtual_heights[indice])+'\t\t\t'+str(F2_frequencies[indice])+'\n')

        fout.write('\nE_LAYER_RECONSTRUCTION\n')
        fout.write('\nvirtual_heights\t\t\tfrequency\n')
        for indice in range(0,gruppi[17]):
            fout.write(str(E_virtual_heights[indice])+'\t\t\t'+str(E_frequencies[indice])+'\n')

        fout.write('\nEs_LAYER_RECONSTRUCTION\n')
        fout.write('\nvirtual_heights\t\t\tfrequency\n')
        for indice in range(0,gruppi[43]):
            fout.write(str(Es_virtual_heights[indice])+'\t\t\t'+str(Es_frequencies[indice])+'\n')
#--------------------------------------------------------------------------------------------------------------------

#--------------     preparo la strutturadel file Json    ------------------------------------------------------           
    big_lista=[]            #grossa lista costituente il blocco che verrà scritto nel file json

    #creo il dizionario dei parametri ionosferici
    dizio_param= {'foF2':foF2,
                  'foF1':foF1,
                  'M3000F2':M3000F2,
                  'MUF3000F2':MUF3000F2,
                  'fmin':fmin,
                  'foEs':foEs,
                  'foE':foE,
                  'fxI':fxI,
                  'h_F':h_F,
                  'h_F2':h_F2,
                  'h_E':h_E,
                  'h_Es':h_Es,
                  'TEC':TEC
                 }


    big_lista.append(dizio_param)
    
    density_lista=[]        #lista di dizionari della densità elettronica {f:freq,h:altezza}
    Es_lista=[]             #lista di dizionari della traccia ricostruita Es {f:freq,h:altezza}
    E_lista=[]              #lista di dizionari della traccia ricostruita E {f:freq,h:altezza}
    F1_lista=[]             #lista di dizionari della traccia ricostruita F1 {f:freq,h:altezza}
    F2_lista=[]             #lista di dizionari della traccia ricostruita F2 {f:freq,h:altezza}
        
   

    for indice in range (0,gruppi[51]):
        density_lista.append({"f":plasma_frequency[indice],"h":true_height[indice]})
 
    for indice in range (0,gruppi[43]):
        Es_lista.append({"f":Es_frequencies[indice],"h":Es_virtual_heights[indice]})


    for indice in range (0,gruppi[17]):
        E_lista.append({"f":E_frequencies[indice],"h":E_virtual_heights[indice]})

    for indice in range (0,gruppi[12]):
        F1_lista.append({"f":F1_frequencies[indice],"h":F1_virtual_heights[indice]})
    
    for indice in range (0,gruppi[7]):
        F2_lista.append({"f":F2_frequencies[indice],"h":F2_virtual_heights[indice]})
        
        

    big_lista.append(density_lista)
    big_lista.append(Es_lista)
    big_lista.append(E_lista)
    big_lista.append(F1_lista)
    big_lista.append(F2_lista)
    
    #print(big_lista)
    with open(JSON_dir+'\\'+nome_file+'.json','w') as fout:
        json.dump(big_lista,fout)
        
    #os.rename(SAO_dir+'\\'+file,DONE_dir+'\\'+file)



