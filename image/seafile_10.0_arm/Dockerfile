# See https://hub.docker.com/r/phusion/baseimage/tags/
FROM phusion/baseimage:focal-1.0.0-arm64
ENV SEAFILE_SERVER=seafile-server SEAFILE_VERSION=

RUN echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list \
    && curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add -

# Security
RUN apt-get update --fix-missing && apt-get upgrade -y

# Utility tools
RUN apt-get install -y vim htop net-tools psmisc wget curl git unzip

# For suport set local time zone.
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y tzdata \
    nginx \
    libmysqlclient-dev \
    libmemcached11 libmemcached-dev \
    fuse \
    ldap-utils ca-certificates

# Python3
RUN apt-get install -y python3 python3-pip python3-setuptools && \
    rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python && \
    python3 -m pip install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir --timeout=3600 click termcolor colorlog pymysql django==3.2.* \
    future==0.18.* mysqlclient==2.1.* pillow==10.2.* pylibmc captcha==0.5.* markupsafe==2.0.1 jinja2 \
    sqlalchemy==1.4.3 django-pylibmc django_simple_captcha==0.5.20 pyjwt==2.6.* djangosaml2==1.5.* pysaml2==7.2.* pycryptodome==3.16.* cffi==1.15.1 psd-tools lxml

# Scripts
COPY scripts_10.0 /scripts
COPY templates /templates
COPY services /services

# acme
# RUN curl https://get.acme.sh | sh -s
RUN unzip /scripts/acme.sh-master.zip -d /scripts/ && \
    mv /scripts/acme.sh-master /scripts/acme.sh && \
    cd /scripts/acme.sh && /scripts/acme.sh/acme.sh --install

RUN echo "TLS_REQCERT     allow" >> /etc/ldap/ldap.conf && \
    chmod u+x /scripts/* && rm /scripts/cluster* && \
    mkdir -p /etc/my_init.d && \
    rm -f /etc/my_init.d/* && \
    cp /scripts/create_data_links.sh /etc/my_init.d/01_create_data_links.sh && \
    mkdir -p /etc/service/nginx && \
    mkdir -p /etc/nginx/sites-enabled && mkdir -p /etc/nginx/sites-available && \
    rm -f /etc/nginx/sites-enabled/* /etc/nginx/conf.d/* && \
    mv /services/nginx.conf /etc/nginx/nginx.conf && \
    mv /services/nginx.sh /etc/service/nginx/run

# Seafile
WORKDIR /opt/seafile
COPY seafile-server-${SEAFILE_VERSION} /opt/seafile/seafile-server-${SEAFILE_VERSION}

EXPOSE 80

CMD ["/sbin/my_init", "--", "/scripts/enterpoint.sh"]
