FROM debian:buster
ENV DEBIAN_FRONTEND='noninteractive'
RUN apt update

# dependencies
RUN  apt install -y autoconf automake autotools-dev bash-completion bison build-essential comerr-dev \
debhelper flex g++ git gperf groff heimdal-dev libbsd-resource-perl libclone-perl libconfig-inifiles-perl \
libcunit1-dev libdatetime-perl libdb-dev libdigest-sha-perl libencode-imaputf7-perl libfile-chdir-perl \
libglib2.0-dev libical-dev libio-socket-inet6-perl libio-stringy-perl libjansson-dev libldap2-dev \
libnet-server-perl libnews-nntpclient-perl libpam0g-dev libpcre3-dev libsasl2-dev \
libsnmp-dev libsqlite3-dev libssl-dev libtest-unit-perl libtool libunix-syslog-perl liburi-perl \
libxapian-dev libxml-generator-perl libxml-xpath-perl libxml2-dev libwrap0-dev libzephyr-dev lsb-base \
net-tools perl php-cli php-curl pkg-config po-debconf tcl-dev \
transfig uuid-dev vim wamerican wget xutils-dev zlib1g-dev sasl2-bin rsyslog sudo acl telnet rsync \
libsasl2-modules sasl2-bin libsasl2-modules-gssapi-mit \
libchardet1 libnghttp2-dev libwslay-dev ssl-cert


RUN apt-get -y  install libxapian-dev

# download cyrus
RUN wget https://github.com/cyrusimap/cyrus-imapd/releases/download/cyrus-imapd-3.2.3/cyrus-imapd-3.2.3.tar.gz
RUN tar -xzvf cyrus-imapd-3.2.3.tar.gz

# configure cyrus
WORKDIR /cyrus-imapd-3.2.3

RUN autoreconf -i -s 
RUN ./configure --enable-http --enable-jmap --enable-xapian --prefix=/usr/cyrus
RUN make
RUN make install

## define conf
ADD cyrus.conf /etc/cyrus.conf
ADD imapd.conf /etc/imapd.conf

# Setting up  syslog
RUN echo "local6.*        /var/log/cyrus_imapd.log" >> /etc/rsyslog.d/cyrus.conf 
RUN echo "auth.debug      /var/log/cyrus_auth.log" >> /etc/rsyslog.d/cyrus.conf 
# avoid writing to kernel log
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf
# create user and group

RUN groupadd -fr mail
RUN useradd -c "Cyrus IMAP Server" -d /var/lib/cyrus -g mail -s /bin/bash -r cyrus
RUN usermod -aG ssl-cert cyrus

# Authentication with SASL (Ubuntu uses saslauth group, Debian uses sasl group.)
RUN groupadd -fr sasl

RUN usermod -aG sasl cyrus
ADD saslauthd /etc/default/saslauthd
# cyrus file storage
RUN mkdir -p /var/lib/cyrus /var/spool/cyrus /run/cyrus
RUN chown -R cyrus:mail /var/lib/cyrus /var/spool/cyrus /run/cyrus
RUN chmod 750 /var/lib/cyrus /var/spool/cyrus /run/cyrus

RUN sudo -u cyrus ./tools/mkimap

# Install sendmail

## Hack to allow to install sendmail quick, else refreshing aliases takes minutes
## must be in one command else Docker creates a new image with a new /etc/hosts during the build
RUN echo "127.0.0.1 $HOSTNAME $HOSTNAME.localdomain" >> /etc/hosts && apt install -y sendmail
ADD sendmail.mc /etc/mail/sendmail.mc
RUN echo "127.0.0.1 $HOSTNAME $HOSTNAME.localdomain" >> /etc/hosts && sendmailconfig

## create socket directory to communicate between Sendmail et Cyrus by LMTP

RUN mkdir -p /var/run/cyrus/socket
RUN chown cyrus:mail /var/run/cyrus/socket
RUN chmod 750 /var/run/cyrus/socket

## expose ports
EXPOSE 143
EXPOSE 80
EXPOSE 25

## Launch cyrus
ADD run.sh run.sh
RUN chmod +x run.sh
CMD sh run.sh
