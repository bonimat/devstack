#!/usr/bin/env bash

set -e

# resetti i valori
unset DEVSTACK_DB
unset DS_PGDATA
unset DEVSTACK_WWWROOT
unset DEVSTACK_JENKINS_HOME
unset DEVSTACK_JENKINS_PORT

# Settaggi di configurazione
export DEVSTACK_DB=pgsql
export DS_PGDATA="/home/matteo/Workspaces/Supporto/DatabaseDiSviluppo/pgdata"
export DEVSTACK_WWWROOT=$(echo $PHPP)
export DEVSTACK_JENKINS_HOME="/home/matteo/Workspaces/JenkinsProjects"
#export DEVSTACK_JENKINS_PORT="18080"

# Visualizzazione dei settaggi
echo "DB: $DEVSTACK_DB"
echo "DATA DB: $DS_PGDATA"
echo "Web: $DEVSTACK_WWWROOT"
echo "Jenkins: $DEVSTACK_JENKINS_HOME"
echo "Jenkins port:$DEVSTACK_JENKINS_PORT"