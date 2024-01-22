### Gestione dei files di log del sistama
I files di log prodotti dai singoli docker vengono passati a rsyslog.d, tramite una regola descritta nel file 01-docker-swit.conf i files vengono salvati nella dir /var/log/swit/.
Settimanalmente, grazie al progemma logrotate i log vengono rotati e salvati in una dir della san per la salvagiardia
Passi da seguire:
1. cp 01-docker-swit.conf /etc/rsyslog.d/
2. reboot rsyslog.service
3. cp swit_logrotate.conf /usr/local/etc/
4. chown root:root /usr/local/etc/swit_logrotate.conf
5, add row to root crontab
   0   1   *   *   4  /usr/sbin/logrotate -s /usr/local/etc/swit_logrotate.status /usr/local/etc/swit_logrotate.conf >> /home/eswua/log/logrotate.log 2>&1
 
