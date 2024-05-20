# Dockerfile SwitWs

FROM python:3.11.0

MAINTAINER Massimo Viola <massimo.viola@ingv.it> version: 1.0

WORKDIR /srv

RUN apt-get update && \
    apt-get install -y jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
	pip install -r requirements.txt

COPY healthcheck.sh /home/healthcheck.sh
RUN chmod +x /home/healthcheck.sh

CMD ["python3","wsgi.py"]