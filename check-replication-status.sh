#!/bin/bash
# Um script para monitorar a replicação do MySQL em sistemas Linux - Eulabs
# Criado por Welligton Alves - Linux4Life
# Adicione ao cron:
# */1 * * * * bash /opt/NoOps/check-replication.sh

HOSTNAME=$(hostname)
IP=$(hostname -I)
arquivo="$PWD/replicationStatus.txt"
MONITOR="$EulabsMonitor"
USER=" " # <------< Variável para o usuario do banco 
PASS=" " # <------< Variável para a senha do banco
ID=" " # <------< Variável para o numero do do celular ou id do grupo
AUTH_TOKEN=" " # <------< Variável para o token
NOTIFICATION_URL=" "  # <------< Variável para a URL da notificação

# Checando o status de replicação do MySQL e salvando em um arquivo temporário
/usr/local/mysql/bin/mysql -u $USER -p$PASS -e 'SHOW SLAVE STATUS\G' | grep 'Running:\|Master_Host:\|Last_SQL_Error:' > "$arquivo"

# Exibindo os resultados
echo "Resultados:"
cat "$arquivo"

# Verificando os parâmetros
slaveRunning=$(grep -c "Slave_IO_Running: Yes" "$arquivo")
slaveSQLRunning=$(grep -c "Slave_SQL_Running: Yes" "$arquivo")
secondsBehind=$(grep "Seconds_Behind_Master" "$arquivo" | awk '{print $2}')

# Função para enviar notificações
send_notification() {
  local message="$1"
  curl --location "$NOTIFICATION_URL" \
    --header "Content-Type: application/x-www-form-urlencoded" \
    --header "Authorization: Bearer $AUTH_TOKEN" \
    --data-urlencode "id=$ID" \
    --data-urlencode "message=$message"
}

# Notificações baseadas nos resultados
if [[ $slaveRunning -ne 1 || $slaveSQLRunning -ne 1 ]]; then
  message="$MONITOR Problema de replicação encontrado com $HOSTNAME ($IP) em $(date)."
  send_notification "$message"
else
  echo -e "A replicação parece boa em $HOSTNAME ($IP) em $(date)."
fi

if [[ $secondsBehind -gt $ʋ ]]; then
  message="$MONITOR Atraso encontrado na replicação com $HOSTNAME ($IP) em $(date)."
  send_notification "$message"
else
  echo -e "Sem atrasos, a replicação parece boa em $HOSTNAME ($IP) em $(date)."
}
