
FROM ubuntu:15.04
MAINTAINER Conor Heine <conor.heine@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV export LANGUAGE=en_US.UTF-8
ENV export LC_ALL=en_US.UTF-8
ENV export LANG=en_US.UTF-8
ENV export LC_TYPE=en_US.UTF-8

RUN useradd -U --system -m -d /shinken shinken
RUN apt-get update

# Core dependencies
RUN apt-get --yes install \
        lsb-release \
        wget \
        sudo \
        inotify-tools \
        libssl-dev \
        libsys-statistics-linux-perl \
        libapache2-mod-proxy-html \
        supervisor \
        ntp

 # Python
RUN apt-get --yes install \
        python2.7 \
        python-setuptools \
        python-pip \
        python-pycurl \
        python-cherrypy3 \
        python-pymongo \
        python-requests \
        python-arrow \
        python-openssl \
        python-bottle \
        python-crypto

# Pip
RUN pip install docker-py nagiosplugin

# Nagios plugins
RUN apt-get --yes install \
        nagios-plugins \
        nagios-nrpe-plugin 

RUN echo 'shinken ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

RUN wget -O /tmp/shinken.tgz https://github.com/naparuba/shinken/tarball/master
RUN cd /tmp && tar zxvf shinken.tgz && cd nap* && python2.7 setup.py install
RUN cd /tmp/nap* && contrib/install -a mongodb

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN mkdir -p /var/lib/shinken/config /var/lib/shinken/share/photos

# Configuration files
VOLUME /etc/shinken

# Shinken modules
VOLUME /var/lib/shinken

# Log files
VOLUME /var/log/shinken

# PID files
VOLUME /var/run/shinken

# Instance configuration
VOLUME /shinken

USER shinken
WORKDIR /shinken
CMD shinken-arbiter -v -c /etc/shinken/shinken.cfg

