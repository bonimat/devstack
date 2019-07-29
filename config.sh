#!/usr/bin/env bash

set -e

# resetti i valori
unset DEVSTACK_DB
unset DS_PGDATA
unset DEVSTACK_WWWROOT

# Settaggi di configurazione
export DEVSTACK_DB=pgsql
export DS_PGDATA="/home/matteo/Workspaces/Supporto/DatabaseDiSviluppo/pgdata"
export DEVSTACK_WWWROOT=$(echo $PHPP)

# Visualizzazione dei settaggi
echo $DEVSTACK_DB
echo $DS_PGDATA
echo $DEVSTACK_WWWROOT