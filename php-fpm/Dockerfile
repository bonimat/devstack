FROM php:7.2-fpm
ARG XDEBUG_REMOTEIP
ARG XDEBUG_IDEKEY
#ENV PHPFPM_PORT ${DEVSTACK_PHPFPM_PORT2}
#ENV XDEBUG_PORT ${DEVSTACK_XDEBUG_PORT}
#ENV XDEBUG_IDEKEY ${DEVSTACK_XDEBUG_IDEKEY}
#ENV XDEBUG_REMOTEIP ${DEVSTACK_XDEBUG_REMOTEIP}


COPY conf/www.conf /usr/local/etc/php-fpm.d
COPY conf/zz-docker.conf /usr/local/etc/php-fpm.d
COPY conf/php.ini /usr/local/etc/php

RUN echo "${XDEBUG_REMOTEIP}"   
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        zip \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install zip \
    && pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host=${XDEBUG_REMOTEIP}">> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.idekey=${XDEBUG_IDEKEY}">> /usr/local/etc/php/conf.d/xdebug.ini
RUN curl -L -o /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-8.phar
RUN chmod +x /usr/local/bin/phpunit