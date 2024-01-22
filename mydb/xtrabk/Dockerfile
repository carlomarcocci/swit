FROM    ubuntu:18.04
LABEL   MAINTAINER="Carlo Marcocci <carlo.marcocci@ingv.it>"

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

#ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get upgrade -y
RUN apt-get install wget gnupg2 lsb-release curl -y

RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb -P /tmp/
RUN dpkg -i /tmp/percona-release_latest.$(lsb_release -sc)_all.deb

RUN apt-get update
RUN apt-get install percona-xtrabackup-80 -y
RUN apt-get -qq purge wget && \
    apt-get -qq autoclean && apt-get -qq autoremove && rm -rf /tmp/* /var/cache/apt/* /var/cache/depconf/

COPY    entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
