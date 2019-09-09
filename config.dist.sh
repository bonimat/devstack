#!/usr/bin/env bash

## Questo file config.dist.sh, una volta rinominato in config.sh, è utilizzabile per settare una
## configurazione personale diversa rispetto ai valori di default che si trovano sparsi nel file 
## che compondono il docker-compose (yml). E' possibile anche non usare il file e usare usare il
## comando export per impostare il valore della variabile di ambiente che interessa 
## (se è già impostata va resettata con "unset")

set -e

# resetti i valori
unset DEVSTACK_DB
unset DS_PGDATA
unset DEVSTACK_WWWROOT
unset DEVSTACK_JENKINS_HOME
unset DEVSTACK_JENKINS_PORT
unset DEVSTACK_ORACLE_DATA


## Settaggi di configurazione

## scelta del tipo di DB postgres
# export DEVSTACK_DB=pgsql

## scelta del percorso cartella dei dati per postgres 
## es.: export DS_PGDATA="/home/matteo/Workspaces/Supporto/DatabaseDiSviluppo/pgdata"
# export DS_PGDATA=

## scelta del tipo di DB oracle
# export DEVSTACK_DB=oracle

## scelta del percorso cartella dei dati per Oracle
## es.: export DEVSTACK_ORACLE_DATA="/home/matteo/Workspaces/Supporto/DatabaseDiSviluppo/oracle/oradata"

# export DEVSTACK_ORACLE_DATA=

## Percorso dei progetti
## es.:export DEVSTACK_WWWROOT=$(echo $PHPP)
#export DEVSTACK_WWWROOT=

## path della cartella dei dati di jenkins
## es.: export DEVSTACK_JENKINS_HOME="/home/matteo/Workspaces/JenkinsProjects/devstack"
#export DEVSTACK_JENKINS_HOME=

## porta per accedere a jenkins
## es.:export DEVSTACK_JENKINS_PORT="18080"
#export DEVSTACK_JENKINS_PORT="18080"

# Visualizzazione dei settaggi
echo "DB: $DEVSTACK_DB"
echo "DATA Postgress : $DS_PGDATA"
echo "DATA Oracle-xe : $DEVSTACK_ORACLE_DATA"
echo "Web: $DEVSTACK_WWWROOT"
echo "Jenkins: $DEVSTACK_JENKINS_HOME"
echo "Jenkins port: $DEVSTACK_JENKINS_PORT"
