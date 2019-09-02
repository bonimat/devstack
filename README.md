# devStack: Stack per lo sviluppo web by bonimat
Partendo dall'idea avuti dagli sviluppatori di Moodle che hanno realizzato uno stack configurabile, 
questo progetto dovrebbe creare un stack simile ma più simile alla nostra infrastruttura.
Lo stack si basa su kernel Ubuntu (release di partenza è
la 18.04) e da la possibilità di utilizzare i seguenti software:

- apache2 (ver 2.4)
- php fpm (ver 7.2)
- mailhog 
- adminer (gestore web per i DB)
- database (mysql/psql/oracle) (under construction)
- jenkins
# Configurazione 
Lo stack può essere avviato tramite semplice comando basato sul docker-compose dopo avere inizializzato alcune variabili globali come 
indicato nella sezione "Utilizzo".
Per semplificare la configurazioni più elaborate si puo' utilizzare il file config.sh (se nn esiste si puo' creare) in cui inizializzare correttamente(unset e poi export) le variabili globali che servono.
La descrizione delle è presente nella tabella 

Esempio di file **config.sh** :
```
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
echo $DEVSTACK_DB
echo $DS_PGDATA
echo $DEVSTACK_WWWROOT
```


# Utilizzo
Per avviare i container il comando da lanciare è

```
./devStack_docker_compose.sh up -d
```
Per stoppare i container invece:

```
./devStack_docker_compose.sh down
```


Nel caso si siano ridefinite alcune variabili globali come le porte, è opportuno ricreare le immagini lanciando lo stesso comando ma aggiungendo l'opzione __--build__.

```
./devStack_docker_compose.sh up -d --build 
```

Lanciando il comando privo di opzioni si visualizzano le i valori delle variabili globali utilizzati.
```
 ./devstack_docker_compose.sh up -d --build

Settings:
Use default  - wwwroot: $DEVSTACK_WWWROOT=/home/matteo/Workspace/DockerProjects/devStack/html
Use default  port: $DEVSTACK_PORT = 8084
Use default  port: $DEVSTACK_PHPFPM_PORT = 8999
Use default  port: $DEVSTACK_XDEBUG_PORT = 9000
Use default  port: $DEVSTACK_XDEBUG_IDEKEY=PHPSTORM
Use default IP docker0: 172.17.0.1
Use default  db: mysql(to connect with adminer use username:root, db:mysql)
To get IP for connection use: docker inspect devstack_db_1 |grep IPAddress
-f /home/matteo/Workspace/DockerProjects/devStack/db/db.mysql.yml
Use default  port: $DEVSTACK_ADMINER_PORT=8090
docker-compose -f /home/matteo/Workspace/DockerProjects/devStack/base.yml  -f /home/matteo/Workspace/DockerProjects/devStack/db/db.mysql.yml -f /home/matteo/Workspace/DockerProjects/devStack/db/adminer.yml -f /home/matteo/Workspace/DockerProjects/devStack/mailhog/service.mail.yml up -d --build

```

|Variabile Globale | Default |Descrizione|
|------------------|----|------------|
|DEVSTACK_WWWROOT| $(pwd)/html  | percorso della "document root", path assoluta dove si trova il codice che verrà interpretato dal web server  |
|DEVSTACK_PORT| 8082  | porta del sito web. Il sito web avrà il seguente indirizzo http://localhost:8082 |
|DEVSTACK_PHPFPM_PORT| 8999 | è la porta con la quale apache2 e php-fpm comunicano, TCP socket  |
|DEVSTACK_XDEBUG_PORT| 9000 | è la porta con la quale xdebug espone le informazioni per il debug |
|DEVSTACK_XDEBUG_IDEKEY| PHPSTORM | è la id per l'identificazione delle sessione attiva dell'Xdebug |
|DEVSTACK_ADMINER_PORT| 8090 | è la porta per accedere al client web per la gestione dei DB
|DEVSTACK_DB|empty| cambiare con 'pgsql' per utilizzare  PostGres (pgsql) anziché Mysql |
|DS_PGDATA| export DS_PGDATA="/home/matteo/Workspaces/Supporto/DatabaseDiSviluppo/pgdata"| Nel caso il db fosse postgress|
|DEVSTACK_JENKINS_HOME| empty| contiente il percorso condiviso di jenskins (jenkins_home)| [VariabiliGlobali]
|DEVSTACK_JENKINS_PORT| 8080| porta su a cui accedere per raggiungere il servizio|
Nota: L'unica variabile che si dovrebbe avere l'esigenza di impostare è **DEVSTACK_WWWROOT**.
Alcuni comandi comodi potrebbero essere: 
```
# export DEVSTACK_WWWROOT=<percorso progetti php>
oppure 
# export DEVSTACK_WWWROOT=$(echo $PHPP)
```

se nella percorso **\<percorso progetti php\>** o **$PHPP** abbiamo i nostri progetti ad esempio
```
tree -L 1
.
├── Librerie
├── prova.php
└── ProvaProgettoXXX1

```
Allora i nostri codici saranno visualizzabili ai seguenti indirizzi:
```
http:\\localhost:8082\Librerie
http:\\localhost:8082\prova.php
http:\\localhost:8082\ProvaProgettoXXX1
```
## Cartella data

La cartella del progetto **./data** può essere utilizzata come cartella share. I permessi di scrittura devono essere impostati esternamente.
Il suo percorso all'interno dei container apache2 e php7.2-fpm è
```
data:/data/moodledata/iol_local-data
```


## Mailhog e PHPunit
Nel percorso
```
http:\\localhost:8025
```
avremo l'applicazione di **Mailhog** che mostrerà le mail intercettate.
All'interno del container del php è presente la libreria **PHPunit versione 8** (installata come phar) compatibile con php 7.2 fpm (percorso interno al container /usr/local/bin/phpunit). La libreria usata è anche se presente nel progetto(php-fpm/phpunitlibrary/phpunit-8.phar) è pero' scaricata da web. 

# Postgres 
## In generale
```
export DEVSTACK_DB=pgsql

export DS_PGDATA=$(pwd)/pgdata

docker exec -ti ds_pgsql psql -U matteo pgdb

```
Per accedere da web:
```
Sistema: PostrgesSQL	
Server: db	
Utente: matteo	
Password: bonimat
Database: pgdb
```
## Utilizzo
Dichiarare le variabili:
```
cd $DOCKER/devstack
export DEVSTACK_DB=pgsql
export DS_PGDATA=/home/matteo/Workspaces/Supporto/DatabaseDiSviluppo/pgdata
export DEVSTACK_WWWROOT=$(echo $PHPP)

./devstack_docker_compose.sh up -d
```
## Soluzione di alcuni problemi
Alla avvio del container assicurarsi di avere la cartella dei dati del db (DS_PGDATA) **VUOTA** altrimenti il container rimane in uno stato di continuo restarting.

# Debug
Nel caso alcuni container abbiano dei problemi si possono usare alcuni utili comandi.
Per accedere dentro il container :
```
docker exec -it <nome del container > /bin/bash
```

Oppure più in generale per sapere i log del container:

```
docker logs <nome del container>
```






# Realizzazione
## Idea di partenza
Nella versione dello stack creata dagli sviluppatori di Moodle (versione Moodle), nella *cartella bin/moodle-docker-compose* e' presente un insieme di condizioni che costruiscono la stringa finale con cui viene lanciato il docker-compose.

Il risultato più interessante è che alla fine troviamo la linea di comando costruita con l'aggiunta dei parametri con cui è lanciato il mooodle-docker-compose ('$@': in questo indirizzo si trova un esempio per capire a cosa serve https://superuser.com/questions/694501/what-does-mean-as-a-bash-script-function-parameter ).

La stringa di comando parte così:
~~~
dockercompose="docker-compose -f ${basedir}/base.yml"
dockercompose="${dockercompose} -f ${basedir}/service.mail.yml"
~~~

Quindi per lanciare diversi parti di script da file è suffficiente scrivere un file yaml e usarlo con compose preceduto dalla option "-f".

Esempio:
~~~
> docker-compose -f /home/matteo/Workspaces/DockerProjects/moodle-docker/base.yml -f /home/matteo/Workspaces/DockerProjects/moodle-docker/service.mail.yml -f /home/matteo/Workspaces/DockerProjects/moodle-docker/db.mysql.yml -f /home/matteo/Workspaces/DockerProjects/moodle-docker/webserver.port.yml up -d
~~~

## Operazioni preliminari
### Definire le variabili di ambiente:
es.
~~~
> export DEVSTACK_WWWROOT=$(pwd)/html
> echo $DEVSTACK_WWWROOT 
/home/matteo/Workspaces/DockerProjects/devStack/html
~~~


### Porte utilizzate:
Le porte utilizzata internamente è la 9000 (attenzione alla direttiva che fa comunicare fpm con apache2: ho trovato un post (https://stackoverflow.com/questions/41306112/why-cant-apache-communicate-with-php-fpm-in-separate-containers-using-docker-de) che spiega come la comunicazione per socket tcp deve essere trasmessa usando il servizio 'php' che la Docker network associa come nome DNS e non usando l'indirizzo 127.0.0.1 perché indirizzo di rete locale. Il php è apache2 non risiedono su un host comune con docker, ma sono servizi isolati).
Le porte esposte per default sono la **8082** per l'http e la **8445** per https.
Le porte per l'utilizzo di **mailhog** sono **8025** e la **1025**.
Le porta per accedere al client db **Adminer** è **8090** 


# Comandi Utili
Dopo vari tentativi il risultato è 

   - docker-compose -f base.yml per lanciare un server web apache2 di binami con volume "html/" e porta 8082
~~~
docker-compose -f base.yml up -d
docker-compose -f base.yml down
~~~
per ricostruire le immagini
docker-compose -f base.yml up -d --build

   - dockerfile in apache che puo' creare un container con lo stesso risultato ma sulla porta 8082, ma personalizzato con kernel ubuntu e installazione di apache2:
~~~
docker run -d -p 8082:80 -v $DEVSTACK_WWWROOT:/var/www/html --name app app
docker container stop app
~~~
per rimuovere i container stoppati:
~~~
docker container prune
~~~
