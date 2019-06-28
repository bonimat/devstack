FROM ubuntu:latest
MAINTAINER bonimat

RUN apt-get update
RUN apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2  curl \
            apache2-doc apache2-utils libapache2-mod-php 

# Enable apache mods.
RUN a2enmod rewrite ssl actions include cgi proxy_fcgi alias setenvif
RUN a2dismod php7.2

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

ENV PHPFPM_PORT ${DEVSTACK_PHPFPM_PORT}

EXPOSE 80
EXPOSE $DEVSTACK_PHPFPM_PORT

#Copy configuration for php.fpm
COPY conf/php-fpm.conf /etc/apache2/conf-available
COPY conf/000-default.conf /etc/apache2/sites-available

RUN a2enconf php-fpm
RUN a2ensite 000-default.conf


# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND