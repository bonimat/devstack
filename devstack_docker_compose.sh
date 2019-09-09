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

#Impostazioni di default
fileconf=${basedir}/config.sh 
if [ -f $fileconf ];
then
    echo 'Execute config.sh'
    source "$(pwd)/config.sh"
fi

# Controllo varibiali di ambiente:
if [ -z "$DEVSTACK_WWWROOT" ];
then
    export DEVSTACK_WWWROOT="$basedir/html"
    messaggiodefault='Use default '
fi
echo "${messaggiodefault} - wwwroot: \$DEVSTACK_WWWROOT=${DEVSTACK_WWWROOT}"

if [ -z "$DEVSTACK_PORT" ];
then
    export DEVSTACK_PORT=8084
    messaggiodefault='Use default '
fi
echo "${messaggiodefault} port: \$DEVSTACK_PORT = 8084"

if [ -z "$DEVSTACK_PHPFPM_PORT" ];
then
    export DEVSTACK_PHPFPM_PORT=8999
    messaggiodefault='Use default '
fi
echo "${messaggiodefault} port: \$DEVSTACK_PHPFPM_PORT = 8999"

if [ -z "$DEVSTACK_XDEBUG_PORT" ];
then
    export DEVSTACK_XDEBUG_PORT=9000
    messaggiodefault='Use default '
fi
echo "${messaggiodefault} port: \$DEVSTACK_XDEBUG_PORT = 9000"

if [ -z "${DEVSTACK_XDEBUG_IDEKEY}" ];
then
    export DEVSTACK_XDEBUG_IDEKEY=PHPSTORM
    messaggiodefault='Use default '
fi
echo "${messaggiodefault} port: \$DEVSTACK_XDEBUG_IDEKEY=PHPSTORM"

export DEVSTACK_XDEBUG_REMOTEIP=$(ip -4 addr show docker0 | grep -Po 'inet \K[\d.]+')
echo "Use default IP docker0: ${DEVSTACK_XDEBUG_REMOTEIP}"

# Database service
if [ -z "$DEVSTACK_DB" ];
then
    messaggiodefault='Use default '
    echo "${messaggiodefault} db: mysql(to connect with adminer use username:root, db:mysql)"
    echo "To get IP for connection use: docker inspect devstack_db_1 |grep IPAddress"
    dockercompose="${dockercompose} -f ${basedir}/db/db.mysql.yml"
fi

if [ "$DEVSTACK_DB" = 'pgsql' ];
then
    if [ -z "$DS_PGDATA" ];
    then
        export DS_PGDATA="$(pwd)/pgdata"
        echo "Postgress Data: ${DS_PGDATA}"
    fi
    echo "${messaggiodefault} db: ${DEVSTACK_DB} (to connect with adminer use username:postgres, db empty)"
    echo "To get IP for connection use: docker inspect devstack_db_1 |grep IPAddress"
    dockercompose="${dockercompose} -f ${basedir}/db/db.${DEVSTACK_DB}.yml"
fi

if [ "$DEVSTACK_DB" = 'oracle' ];
then
    if [ -z "$DEVSTACK_ORACLE_DATA" ];
    then
        export DEVSTACK_ORACLE_DATA="$(pwd)/oracle_data"
        echo "Oracle Data: ${DEVSTACK_ORACLE_DATA}"
    fi
    echo "${messaggiodefault} db: ${DEVSTACK_DB} (to connect with adminer use username:???, db empty)"
    echo "To get IP for connection use: docker inspect devstack_db_1 |grep IPAddress"
    dockercompose="${dockercompose} -f ${basedir}/db/db.${DEVSTACK_DB}.yml"
fi



# Adminer service
if [ -z "${DEVSTACK_ADMINER_PORT}" ];
then
    export DEVSTACK_ADMINER_PORT=8090
    messaggiodefault='Use default '
fi
dockercompose="${dockercompose} -f ${basedir}/db/adminer.yml"
echo "${messaggiodefault} port: \$DEVSTACK_ADMINER_PORT=8090"


dockercompose="docker-compose -f ${basedir}/base.yml ${dockercompose}"

# Mailhog service
export DEVSTACK_CONFMAILHOG="${basedir}/mailhog/conf"
dockercompose="${dockercompose} -f ${basedir}/mailhog/service.mail.yml"

# JeNkins service
if [ ! -z "$DEVSTACK_JENKINS_HOME" ];
then
    if [ -z "$DEVSTACK_JENKINS_PORT" ];
    then
        export DEVSTACK_JENKINS_PORT='8080'
    fi

    echo "Enable Jenkins service on port $DEVSTACK_JENKINS_PORT"
    dockercompose="${dockercompose} -f ${basedir}/jenkins/jenkins.yml"
fi

 #!/bin/bash
 if [ "$#" -eq  "0" ]
   then
     echo "Run '.\\devstack_docker_compose up -d' or '.\\devstack_docker_compose up -d --build' to run (and build) containers"
 else
    echo "${dockercompose} $@"
    $dockercompose $@ 
fi