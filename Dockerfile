FROM ubuntu:16.04

MAINTAINER Kuenn Leow <knnleow@gmail.com>

EXPOSE 80 443

# Set noninteractive mode for apt-get
ENV DEBIAN_FRONTEND noninteractive

ARG mysslsubject="/C=SG/ST=Singapore/L=Singapore/O=demo.co/OU=demo_lab/CN=svr01.demo.co/emailAddress=user01@demo.co"
ARG myloginuser="demouser"
ARG myregion="Asia"
ARG mycountry="Singapore"

RUN apt-get update && apt-get upgrade -y 
RUN apt-get autoremove -y

RUN TITLE="Install all my common packages" && \
apt-get install -y \
 apache2-utils \
 curl \
 vim \
 wget \
 whois \
 inetutils-ping \
 lynx \
 telnet \
 host \
 dnsutils \
 htdig \
 pwgen \
 python-setuptools \
 unzip \
 git

RUN TITLE="Install php packages" && \
apt-get install -y \
 php7.0 \
 php7.0-fpm \
 php7.0-mysql

RUN TITLE="Install mysql client" && \
apt-get install -y \
 mysql-client

RUN TITLE="Install Wordpress Dependencies" && \
apt-get install -y \
 php7.0-curl \
 php7.0-gd \
 php7.0-intl \
 php7.0-imap \
 php7.0-mcrypt \
 php7.0-pspell \
 php7.0-recode \
 php7.0-sqlite \
 php7.0-tidy \
 php7.0-xmlrpc \
 php7.0-xsl \
 php7.0-cli \
 php-pear \
 php-imagick \
 php-memcache

RUN TITLE="Install nginx packages" && \
apt-get install -y \
 nginx

RUN TITLE="Add template.d n  script.d Folders" && \
 rm -f /etc/nginx/sites-enabled/default
ADD template.d/nginx/default-kuenn-php7.0-fastcgi  /etc/nginx/sites-enabled/default
ADD script.d/run-all.sh-php7-ubt1604 /script.d/run-all.sh
ADD script.d/run-once.sh /script.d/run-once.sh
ADD script.d/run-once.txt /script.d/.run-once

ADD script.d /script.d
RUN TITLE="Add script.d Folders" && \
 chmod 755 /script.d/*.sh && \
 touch /script.d/.run-once && \
 cp /script.d/run-all.sh-php7-ubt1604 /script.d/run-all.sh

RUN TITLE="Create phpinfo.php file - Troubleshooting" && \
 /bin/echo "<?php phpinfo (); ?>" > /var/www/html/phpinfo.php.txt 

RUN TITLE="Create nginx web folders" && \
 mkdir /var/www/html/peoples && \
 mkdir /var/www/html/products && \
 mkdir /var/www/html/static

# Command to run
ENTRYPOINT ["/script.d/run-all.sh"]
CMD [""]
