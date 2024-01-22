FROM ubuntu:18.04
MAINTAINER Carlo Marcocci <carlo.marcocci@ingv.it> version: 1.1

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt-get update  && apt-get upgrade -y 
RUN apt-get install php7.2 vim less net-tools php-common php-mysql php-cli wget gnupg2 mysql-client apt-utils -y
RUN apt-get install php7.2-xml php-pgsql php-mbstring php-gd -y

RUN apt-get install software-properties-common -y

RUN apt-get update && apt-get -y upgrade --fix-missing
# installation wine
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wine32 

# install python
RUN apt-add-repository -y ppa:deadsnakes/ppa
RUN apt install -y python3.7 python3-pip 
RUN pip3 install mysql-connector
