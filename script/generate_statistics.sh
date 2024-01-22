#!/bin/bash

# eswyaj
zcat /var/log/nginx/eswuaj_access.log*.gz > /tmp/loggone
##
## storico senza siti interni e senza crawlers
cat /tmp/loggone | grep -v "^10." | grep -v "^172." | docker run -p 7890:7890 --rm -i -e LANG=$LANG allinurl/goaccess -a -o html --log-format COMBINED --ignore-crawlers - > /sandata/prod/swit/web/eswuaj/www/html/images/homeimg/goacces-eswuaj-historical.html
##
## storico solo crawlers
cat /tmp/loggone | grep -v "^10." | grep -v "^172." | docker run -p 7890:7890 --rm -i -e LANG=$LANG allinurl/goaccess -a -o html --log-format COMBINED --crawlers-only - > /sandata/prod/swit/web/eswuaj/www/html/images/homeimg/goacces-eswuaj-historical_noint_crawlers.html

cat /var/log/nginx/eswuaj_access.log* > /tmp/logghino
##
## giornaliero senza siti interni senza crawlers
cat /tmp/logghino | grep -v "^10." | grep -v "^172." | docker run -p 7890:7890 --rm -i -e LANG=$LANG allinurl/goaccess -a -o html --log-format COMBINED --ignore-crawlers - > /sandata/prod/swit/web/eswuaj/www/html/images/homeimg/goacces-eswuaj.html

# ws-eswua
zcat /var/log/nginx/ws-eswua_access.log*.gz > /tmp/loggonews
## storico  senza siti interni semza crawlers
cat /tmp/loggonews | grep -v "^10." | grep -v "^172." | docker run -p 7890:7890 --rm -i -e LANG=$LANG allinurl/goaccess -a -o html --log-format COMBINED --ignore-crawlers - > /sandata/prod/swit/web/eswuaj/www/html/images/homeimg/goacces-ws-eswua-historical.html

cat /var/log/nginx/ws-eswua_access.log* > /tmp/logghinows
##
## giornaliero senza siti interni
cat /tmp/logghinows | grep -v "^10." | grep -v "^172." | docker run -p 7890:7890 --rm -i -e LANG=$LANG allinurl/goaccess -a -o html --log-format COMBINED --ignore-crawlers - > /sandata/prod/swit/web/eswuaj/www/html/images/homeimg/goacces-ws-eswua.html

rsync -ax --exclude 'installer' --exclude 'btmp*' /var/log/ /sandata/prod/swit/logs/eswua_srv_log/
