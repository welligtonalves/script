#!/bin/bash
####################################################################
#       Script criado por Welligton Alves Analista eulabs      #####
####################################################################

clear

if [[ $EUID -ne 0 ]]; then
   echo "você deve executar o script como root"
   exit 1
fi

read -p "forneça o nome de login: " nome

# Obter o endereço IP privado
endereco_privado=$(hostname -I)

# Obter o endereço IP público
endereco_publico=$(curl -s ifconfig.me)

echo "verificando se o usuário existe..."
sleep 3

# Verifique se o usuário já existe
if id "$nome" &>/dev/null; then
   echo "processo de criação de usuário cancelado: usuário já existe!"
   exit 1
fi

echo "criando usuário..."
sleep 3

# Gerar uma senha aleatória
senha=$(date | md5sum | head -c8)

# Criar o usuário
useradd -m -d "/home/$nome" -p "$(openssl passwd -1 $senha)" -c "$nome" -s /bin/bash "$nome"

echo "criando diretório do usuário..."
sleep 3

# Criar o diretório .ssh e o arquivo authorized_keys
mkdir -p "/home/$nome/.ssh"
touch "/home/$nome/.ssh/authorized_keys"

echo "tornando o usuário dono do diretório /home/$nome..."
sleep 3

chown -R "$nome:$nome" "/home/$nome"

echo "definindo permissões 0700 no diretório .ssh e 0600 no arquivo authorized_keys..."
sleep 3

chmod 0700 "/home/$nome/.ssh"
chmod 0600 "/home/$nome/.ssh/authorized_keys"

echo "editando o arquivo authorized_keys, adicione a chave SSH do usuário e pressione <Enter> para continuar"
read
sleep 3

# Use o editor de texto padrão para editar o arquivo authorized_keys
sudo -u "$nome" vim "/home/$nome/.ssh/authorized_keys"

echo "arquivo editado com sucesso!!! continuando com o script..."
sleep 3

echo "adicionando usuário ao grupo sudo..."
sleep 3

# Verifique se o grupo sudo ou wheel existe e adicione o usuário apropriado
if grep -qE "^%sudo|^%wheel" /etc/sudoers; then
  usermod -aG sudo "$nome"
else
  echo "não foi possível encontrar o grupo sudo ou wheel no arquivo /etc/sudoers."
fi

echo "usuário $nome agora pertence ao grupo sudo!"
echo "usuário $nome criado com sucesso. senha de acesso: $senha"
echo "endereço IP privado: $endereco_privado"
echo "endereço IP público: $endereco_publico"

sleep 3

exit
