FROM php:7.2-fpm

COPY conf/www.conf /usr/local/etc/php-fpm.d
COPY conf/zz-docker.conf /usr/local/etc/php-fpm.d
COPY conf/php.ini /usr/local/etc/php


#RUN pecl install xdebug-2.6.0 \
#    && docker-php-ext-enable xdebug