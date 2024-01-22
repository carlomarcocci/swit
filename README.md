# swit

Space Weather Information Technology

## Istallazione del sistema
Il deploy del progetto va eseguiro utilizzando il docker-compose. Tutti i servizi nevessari sono realizzati tramite un docker.

### Sistema
1. Debian 9
2. Docker version 19
3. docker-compose version 1.25.4
4. opensshserver
5. mysql-client
6. postgres client

Note:

**Installazione docker**:

1. Il docker da installare è la versione CE, seguire la guida: https://docs.docker.com/engine/install/ubuntu/  

2. Per evitare conflitti con IP di istituto e per attribuire i permessi eseguire:
  - sudo vim /etc/docker/daemon.json
  - aggiungere riga:  
    "bip": "172.18.0.1/24"                                                                                              
  - sudo systemctl restart docker.service 
  - attribuire i permessi:
    vim/etc/gruop  -> cerco gruppo docker e aggiungo l'user alla riga ---> docker:x:999:user  

**Installazione client mysq** (va installato il mysql server 8 e non il semplice client 5.7):

1. Eseguire i seguenti comandi:
- sudo dpkg -i mysql-apt-config_0.8.11-1_all.deb
- sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 8C718D3B5072E1F5
- sudo apt-get update
- sudo apt-get install mysql-client

2. all'avvio dell'isntallazione scegliere di abilitare solo i "tools e connector"

**Installare nfs-common**:

1. sudo apt-get install nfs-common

### Installazione

1.    sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

2. autocompletion per docker-composer
     curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose --version | awk 'NR==1{print $|NF}')/contrib/completion/bash/docker-compose > docker-compose 

3. sudo mv docker-compose /etc/bash_completion.d/docker-compose

4. creare la dir /data/swit che verra' usata come datadir del sistema (**da verificare dovrebbe essere git/data? come i comandi di seguito che avevamo dato con riccardo** )
   -  sudo mkdir /git/data
   - sudo chown user:user /git/data
   - NOTA: se si monta un disco esterno vanno effettuate le modifiche al fstab. bisogna evitare che il disco sia montato prima della rete 
   (comando di esempio: 10.230.3.120:/volume2/DATA  /data  nfs  rw,soft,x-systemd.automount,user=swit,password=isacco2020         0 0 )    
  
5. procedura per gestire i path del syslog:
  - sudo vim /etc/rsyslog.d/01-docker-swit.conf 
  - e inserire nel file le seguenti stringhe:  
  $template CUSTOM_LOGS,"/var/log/%programname%.log"                                                                      
  if $programname startswith 'swit_' then ?CUSTOM_LOGS                                                                    
  & ~  
- sudo systemctl restart rsyslog.service

6. Eseguirre il compose: docker-compose up -d

--------------------------------
a questo punto le ultime istruzioni che mi sono ritrovato erano 
- si creano i db
- si deve modificare il crontab x far partire il parser in automatico:
*/5 * * * * docker exec iparser ./load_dirnopause.sh data 3306 >> /data/swit/logs/iparser/iparser.log 2>&1
- bisogna fargli la directory:  mkdir -p /data/swit/logs/iparser

la parte che segue va controllata perchè non credo sia stata fatta nella procedura con riccardo
--------------------------------

7. create i database di servizio:
    - ```./mydb/createAllDb.sh```

4. Creare il db degli utenti dell'ftp
    - ``` ./ftp/myuser.sh ```

5. Creare l'utente sftp e configurare il servizio

6. creare il docker di ionoparser

    - docker build -t "iparser_ais:v0" --rm ./ionoparser/
    - ./ionoparser/createAIS.sh

7. creare i db per il web, eswuaj e grafana:
    - mysql -uroot -p<pass> -heswuadev -P3305 -e "create database eswuaj"
    - zcat /data/swit/backup/sites/eswuaj.dmp.gz | mysql -uroot -p<pass> -heswuadev -P3305 eswuaj
    - mysql -uroot -p<pass> -heswuadev -P3305 -e "create database grafana"
    - zcat /data/swit/backup/sites/grafana.dmp.gz | mysql -uroot -p<pass> -heswuadev -P3305 grafama
    - cat web/grants_mysql.sql | mysql -uroot -p<pass> -heswuadev -P3305



## scintillazioni
i files parsati per la popolazione del database delle scintillazioni "scintillation" sono, al momento, di tre tipi:
* file prodotti dal septentrio, estensione ismr
* file prodotti dai novatel gps, estensione EST, o binatio
* file prodotti dal novatel multicostellazione, file binario RWD

Il parser scritto in php viene lanciato all'interno di un docker che ha in se il php7.2. Il file che viene eseguito Ã¨ il load_dir.sh che, all'interno del docker cerca tutti i file dei tre tipi elencati presenti nel volume /data e su questi lancia il parser.
Bisogna porre attenzione ai due volumi che vengono montati dal docker al momento della creazione:
* /data, la directory che contiente i files da parsare
* /backup, la root dell'albero di dir che viene creato per dalvare i files parsati seguento il principio:
```
    backup/<stazione>/<anno>/<mese>/<giorno>
```
## Procedure in mysql
Ogni file viene inserito all'interno del rispettivo db mysql da una procedure sp_, i valori restituti dalla proc devono essere omogenei per poter esser gestiti allo stesso modo dal programma a prescindere lalla proc chiamata. Di seguito i valori di out delle sp di insert:

sp ins row

0   SELECT 0 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_prn, ' inserted') err_message;
-1  SELECT -1 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_prn, ' nothing happened') err_message;

mysql messages

0   OK
1   SELECT 1 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_prn, ' out of range number') err_message;  EXIT HANDLER FOR SQLEXCEPTION  
2   SELECT 2 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_prn, ' father absent') err_message;        EXIT HANDLER FOR 1452 foreign key
3   SELECT 3 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_prn, ' sqlexception') err_message;         EXIT HANDLER FOR 1264 out of range value for column
4   SELECT 4 err_code, CONCAT('MESSAGE: row: ', in_dt, ' sat: ', in_prn, '\t \tduplicate row') err_message;    EXIT HANDLER FOR 1062 duplicate entry for key unique
-1  errori nei parametri di input

carlo messages
10  SELECT 10 err_code, 0 id_station, 0 id_file, CONCAT('MESSAGE: station not found: ', in_station) err_message;

-- 
-- error code all'interno del codice php

20  catch nell'esecuzione di una chiamataa chiamata alla sp
21  catch nella lettura del file, cant open file
22  catch nella ricerca della stazione nel db

-- output dell funzione push2db
restituisce l'errore dato dal db o il codice 20 se c'Ã¨ stato un errore nella chiamata
20  errore da catch esecuzione sp

## Definizione delle variabili di ambiente
Per uk funzionamento di SWIT vanno definite delle variabili di ambiente che verranno richiamate nel codice.
Le variabili servono a definire le informazioni per la connessione ai db.

- IPARSER_SWIT_HOST        host name per il db swit
- IPARSER_SWIT_PORT        porta del postgres
- IPARSER_SWIT_PASS        password per l'utente switu

- IPARSER_MYSQL_PASS        password per l'utente del db data, in genere writer
- IPARSER_PG_PASS           password per l'utente del db datapg, in genere tecu



