FROM php:8.0-fpm
ARG XDEBUG_PORT
ARG XDEBUG_IDEKEY

ADD setup /setup
ADD files /tmp

ENV ORACLE_HOME="/usr/local/instantclient"
ENV PATH="$ORACLE_HOME:$PATH"
ENV LD_LIBRARY_PATH="$ORACLE_HOME"

RUN chmod 777 /setup && chmod +t /setup
RUN apt-get update && apt-get install unzip
RUN /setup/oci8-extensions.sh
RUN /setup/php-extensions.sh

COPY conf/www.conf /usr/local/etc/php-fpm.d
COPY conf/zz-docker.conf /usr/local/etc/php-fpm.d
COPY conf/php.ini /usr/local/etc/php

RUN echo $XDEBUG_IDEKEY   
RUN pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.mode=debug">> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.start_with_request=yes">> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.idekey=${XDEBUG_IDEKEY}">> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.discover_client_host=true" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/xdebug.ini \
&& echo "xdebug.client_port=${XDEBUG_PORT}" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN curl -L -o /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-9.5.phar
RUN chmod +x /usr/local/bin/phpunit
