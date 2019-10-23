#!/usr/bin/env bash

set -e

echo "Unzip oracle files"

unzip /tmp/instantclient-basic-linux.x64-*.zip -d /usr/local/
rm /tmp/instantclient-basic-linux.x64-*.zip
unzip /tmp/instantclient-tools-linux.x64-*.zip -d /usr/local/
rm /tmp/instantclient-tools-linux.x64-*.zip
unzip /tmp/instantclient-sqlplus-*.zip -d /usr/local/
rm /tmp/instantclient-sqlplus-*.zip
unzip /tmp/instantclient-sdk-*.zip -d /usr/local/
rm /tmp/instantclient-sdk-*.zip

ln -s /usr/local/instantclient_19_3 /usr/local/instantclient
ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus


cp /tmp/*.ora $ORACLE_HOME/network/admin/.


echo 'instantclient,/usr/local/instantclient' | pecl install oci8 && docker-php-ext-enable oci8
echo 'oci8.statement_cache_size = 0' >> /usr/local/etc/php/conf.d/docker-php-ext-oci8.ini                                                                                            