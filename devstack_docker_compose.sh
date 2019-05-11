#!/usr/bin/env bash

## Variabili di Ambiente
# ${DEVSTACK_WWWROOT} : percorso delle risorse da 
set -e

#copiato da moodle-docker-compose
# Nasty portable way to the directory of this script, following symlink,
# because readlink -f not on OSX. Thanks stack overflow..
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
basedir="$( cd -P "$( dirname "$SOURCE" )/" && pwd )"

echo 'Settings:'

# Controllo varibiali di ambiente:
if [ -z "$DEVSTACK_WWWROOT" ];
then
    export DEVSTACK_WWWROOT="$basedir/html"
fi
echo " - Use default wwwroot: \$DEVSTACK_WWWROOT=${DEVSTACK_WWWROOT}"

if [ -z "$DEVSTACK_PORT" ];
then
    export DEVSTACK_PORT=8084
fi
echo " - Use default port: \$DEVSTACK_PORT = 8084"

if [ -z "$DEVSTACK_PHPFPM_PORT" ];
then
    export DEVSTACK_PHPFPM_PORT=8999
fi
echo " - Use default port: \$DEVSTACK_PHPFPM_PORT = 8999"

if [ -z "$DEVSTACK_XDEBUG_PORT" ];
then
    export DEVSTACK_XDEBUG_PORT=9000
fi
echo " - Use default port: \$DEVSTACK_XDEBUG_PORT = 9000"

if [ -z "${DEVSTACK_XDEBUG_IDEKEY}" ];
then
    export DEVSTACK_XDEBUG_IDEKEY=PHPSTORM
fi
echo " - Use default port: \$DEVSTACK_XDEBUG_IDEKEY=PHPSTORM"

export DEVSTACK_XDEBUG_REMOTEIP=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')
echo "Use default IP docker0: ${DEVSTACK_XDEBUG_REMOTEIP}"
if [ -z "$DEVSTACK_DB" ];
then
    echo " - No DB"
fi




dockercompose="docker-compose -f ${basedir}/base.yml"

# Mailhog service
export DEVSTACK_CONFMAILHOG="$basedir/mailhog/conf"
dockercompose="$dockercompose -f ${basedir}/mailhog/service.mail.yml"


# Finale
echo "$dockercompose $@"
$dockercompose $@