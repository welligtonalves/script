#!/bin/bash
# Um script feito para sistemas Linux        #
# Para o monitoramento com o comando PING.   #
#  Create By Welligton Alves - Linux4Life    #

# adicione endereços IP ou hostnames,
# separados por espaços em branco, para serem
# monitorados pelo script.
HOSTS="127.0.0.1 192.168.10.16 192.168.10.25 google"

# sem ping request
CONTADOR=1

# envia relatório no Slack
WEBHOOK="" #informe url webhook slak

for meuhost in $HOSTS
do
    contador=$(ping -v -c $CONTADOR $meuhost | grep 'received' | awk -F',' '{print $2}' | awk '{print $1}')
    if [ $contador -eq 0 ]; then

        curl -X POST -H 'Content-type: application/json' --data "{"text":'O Host: $meuhost está fora do ar (o ping falhou) em $(date)' }" $WEBHOOK

    fi
done
