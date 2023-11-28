#!/usr/bin/env bash

set -e

echo "Unzip oracle files"

unzip /tmp/instantclient-basic-linuxx64*.zip -d /usr/local/
rm /tmp/instantclient-basic-linuxx64*.zip
unzip /tmp/instantclient-tools-linuxx64*.zip -d /usr/local/
rm /tmp/instantclient-tools-linuxx64*.zip
unzip /tmp/instantclient-sqlplus*.zip -d /usr/local/
rm /tmp/instantclient-sqlplus*.zip
unzip /tmp/instantclient-sdk*.zip -d /usr/local/
rm /tmp/instantclient-sdk*.zip

ln -s /usr/local/instantclient_21_12 /usr/local/instantclient
ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus

mkdir -p /usr/local/instantclient_21_12/network/admin
cp /tmp/*.ora $ORACLE_HOME/network/admin/.


echo 'instantclient,/usr/local/instantclient' | pecl install oci8-2.2.0 && docker-php-ext-enable oci8
echo 'oci8.statement_cache_size = 0' >> /usr/local/etc/php/conf.d/docker-php-ext-oci8.ini                                                                                            