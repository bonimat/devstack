FROM php:7.2-fpm

ENV PHPFPM_PORT=${DEVSTACK_PHPFPM_PORT}

COPY conf/www.conf /usr/local/etc/php-fpm.d
COPY conf/zz-docker.conf /usr/local/etc/php-fpm.d
COPY conf/php.ini /usr/local/etc/php


#RUN pecl install xdebug-2.6.0 \
#    && docker-php-ext-enable xdebug