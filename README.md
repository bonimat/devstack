# devStack: Stack per lo sviluppo web by bonimat
parto dal progetto di moodle moodle-docker e modifico per semplificarlo.
lo stack che si vuole è composto da 
- apache2 
- php fpm
- database

in bin/moodle-docker-compose e' presente un insieme di condizioni che costruiscono la stringa finale con cui viene lanciato il docker-compose.

alla fine troviamo la linea di comando costruita alla quale vengono abbinati i parametri con cui è lanciato il mooodle-docker-compose ('$@' un esempio per quale scoopo usarlo lo si trova qui https://superuser.com/questions/694501/what-does-mean-as-a-bash-script-function-parameter ).

La stringa di comando parte così:
~~~
dockercompose="docker-compose -f ${basedir}/base.yml"
dockercompose="${dockercompose} -f ${basedir}/service.mail.yml"
~~~

Quindi per lanciare diversi parti di script da file è suffficiente scrivere un file yaml e abbinarlo al compose con la option "-f".

Esempio:
docker-compose -f /home/matteo/Workspaces/DockerProjects/moodle-docker/base.yml -f /home/matteo/Workspaces/DockerProjects/moodle-docker/service.mail.yml -f /home/matteo/Workspaces/DockerProjects/moodle-docker/db.mysql.yml -f /home/matteo/Workspaces/DockerProjects/moodle-docker/webserver.port.yml up -d

## Operazioni preliminari
### Definire le variabili di ambiente:
es.
~~~
> export DEVSTACK_WWWROOT=$(pwd)/html
> echo $DEVSTACK_WWWROOT 
/home/matteo/Workspaces/DockerProjects/devStack/html
~~~


#LOG
Dopo vari tentativi il risultato è 
1- docker-compose -f base.yml per lanciare un server web apache2 di binami con volume "html/" e porta 8081
docker-compose -f base.yml up -d
docker-compose -f base.yml down
2- dockerfile in apache che puo' creare un container con lo stesso risultato ma sulla porta 8082, ma personalizzato con kernel ubuntu e installazione di apache2:
docker run -d -p 8082:80 -v $DEVSTACK_WWWROOT:/var/www/html --name app app
docker container stop app

per rimuovere i container stoppati:
docker container prune