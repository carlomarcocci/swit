FROM ubuntu:18.04
MAINTAINER Carlo Marcocci <carlo.marcocci@ingv.it> version: 1.1

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

#ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update  && apt-get upgrade -y 
RUN apt-get install php7.2 vim less net-tools php-common php-mysql php-cli wget gnupg2 mysql-client apt-utils -y
RUN apt-get install software-properties-common -y

RUN apt-get update && apt-get -y upgrade
# installation wine
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wine32 

RUN apt-get install php7.2-xml -y
RUN apt-get install php-pgsql -y
RUN apt-get install php-mbstring -y
RUN apt-get install php-gd -y

ENTRYPOINT ["php iono_parse.php -f "]

