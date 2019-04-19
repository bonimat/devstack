# devStack: Stack per lo sviluppo web by bonimat
Partendo dall'idea avuti dagli sviluppatori di Moodle che hanno realizzato uno stack configurabile, 
questo progetto dovrebbe creare un stack simile ma più simile alla nostra infrastruttura.
Iniziamente l'interessa è avere uno stack basato su kernel Ubuntu (l'attuale release sul campo è
la 18.04) che contiene i seguenti software:

- apache2 (ver 2.4)
- php fpm (ver 7.2)
- database (mysql/psql/oracle)
Nella versione degli sviluppatori di Moodle (versione Moodle), in bin/moodle-docker-compose e' presente un insieme di condizioni che costruiscono la stringa finale con cui viene lanciato il docker-compose. L'idea è interessante e la si vuole utilizzare.

Il risultato più interessante è che alla fine troviamo la linea di comando costruita con l'aggiunta dei parametri con cui è lanciato il mooodle-docker-compose ('$@' un esempio per quale scoopo usarlo lo si trova qui https://superuser.com/questions/694501/what-does-mean-as-a-bash-script-function-parameter ).

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
Le porte esposte in prima fase sono la **8082** per l'http e la **8445** per https.


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
