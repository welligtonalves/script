#!/bin/bash
##############################################
#    script feito para sistemas Linux        #
#  Create By Welligton Alves - Linux4Life    #
##############################################
clear

if [[ $EUID -ne 0 ]]; then
echo "Você deve executar o script como root"
   exit 1
fi

while true; do echo -n .; sleep 1; done &
trap "kill $!" SIGTERM SIGKILL

echo -e "executando limpeza Docker"
        echo -e "System Prune"

        sleep 3

        docker system prune -f
        sleep 3

        docker container prune -f
        sleep 3

        docker image prune -a -f
        sleep 3

        docker volume prune -f
        sleep 3

        docker network prune -f

echo -e "limpeza e organizacao de logs docker container"
sleep 3
        truncate -s 0 /var/lib/docker/containers/*/*-json.log
sleep 3
echo done

kill $!
