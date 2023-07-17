#!/bin/bash
# Um script feito para sistemas Linux        #
# Para  monitora a replicação do mysql.      #
#  Create By Welligton Alves - Linux4Life    #
#

HOSTNAME=$(hostname)
IP=$(hostname -I)
arquivo="$PWD/replicationStatus.txt"
WEBHOOK=""          #UrlWebHook 
USER=""             #UsuarioMysql
PASS=""             #SenhaMysql

#Defina o número máximo de segundos atrás do master que será ignorado.
# Se o slave for maior que maximumSecondsBehind, uma mensagem no slack será enviada.
#
maximumSecondsBehind=300

#
# Checando replicação MySQL...
/usr/local/mysql/bin/mysql -u $USER -p$PASS -e 'SHOW SLAVE STATUS \G' | grep 'Running:\|Master:\|Error:' > replicationStatus.txt

#Utilizando 
#mysql -u $USER -p$PASS -e 'SHOW SLAVE STATUS \G' | grep 'Running:\|Master:\|Error:' > replicationStatus.txt

#
# printa o resultado
#
echo "Results:"
cat replicationStatus.txt

#
# checa os parâmentros
#
slaveRunning="$(cat replicationStatus.txt | grep "Slave_IO_Running: Yes" | wc -l)"
slaveSQLRunning="$(cat replicationStatus.txt | grep "Slave_SQL_Running: Yes" | wc -l)"
secondsBehind="$(cat replicationStatus.txt | grep "Seconds_Behind_Master" | tr -dc '0-9')"
#
# Slack Notificação

if [[ $slaveRunning != 1 || $slaveSQLRunning != 1 ]]; then
  echo ""
          curl -X POST -H 'Content-type: application/json' --data "{"text":':x:\n :x:\n Problema de replicação encontrado com o $HOSTNAME $IP em $(date)\n :x:\n :x:\n' }" $WEBHOOK

else
  echo ""
  echo "A replicação parece boa no $HOSTNAME."
fi

if [[ $secondsBehind -gt $maximumSecondsBehind ]]; then
  echo ""
          curl -X POST -H 'Content-type: application/json' --data "{"text":':x:\n :x:\n Atraso na replicação encontrado com o $HOSTNAME $IP em $(date)\n :x:\n :x:\n' }" $WEBHOOK

else
  echo ""
  echo "A replicação parece boa no $HOSTNAME."
fi

while read line; do
echo -e "$line\n";
curl -X POST -H 'Content-type: application/json' --data "{"text":'Informações sobre a replicação no Host: $HOSTNAME\n  $line\n  em $(date)' }" $WEBHOOK
done < $arquivo

fi
