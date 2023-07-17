#!/bin/bash
####################################################################
#       Script criado por Welligton Alves Analista eulabs      #####
####################################################################
clear

if [[ $EUID -ne 0 ]]; then
echo "Você deve executar o script como root"
   exit 1
fi

read -p "Forneca o nome de login: " nome

sleep 3

echo -e "Verificando se o usuario existe!"

cut -d: -f1 /etc/passwd | grep -iw $nome

if [ $? -eq 0 ]; then

echo 'Processo de criancao de usuario cancelado: USUARIO EXISTENTE!'

   exit 1

else

echo -e "Criando usuario"

sleep 3

senha=$(date | md5sum | head -c8)

useradd -m -d /home/$nome -p $(openssl passwd $senha) -c $nome -s /bin/bash $nome

sleep 3

echo -e "Criando diretorio do usuario"

mkdir -p /home/$nome/.ssh

echo -e "Criando arquivo autorized_key"

sleep 3

touch /home/$nome/.ssh/authorized_keys

echo -e "Tornando usuario dono do diretorio /home/$nome"

sleep 3

chown -R $nome:$nome /home/$nome

echo -e "Dando as permissoes 0777 no diretorio .ssh e 0600 no aquivo autorized_key"
sleep 3

chmod 0700 /home/$nome/.ssh
chmod 0600 /home/$nome/.ssh/authorized_keys

echo -e "Editando o arquivo authorized_keys, adicone a chave key do usuario. Pressione: <Enter> para continuar"
read
	sleep 3

	vim /home/$nome/.ssh/authorized_keys

echo -e "Arquivo editado com sucesso!!!, continuando com o script...\n"

sleep 3

echo "USUARIO $nome CRIADO COM SUCESSO. SENHA DE ACESSO: $senha "
sleep 3
fi

echo -e "Adicionando usuario ao grupo sudo"

sleep 3

GRUPO=%sudo

cut -d: -f1 /etc/sudoers | grep -iw $GRUPO

if [ $? -eq 0 ]; then

  usermod -aG sudo $nome

else

  usermod -aG wheel $nome

fi

echo -e "USUARIO $nome AGORA PERTENCE AO GRUPO SUDO!"

sleep 3

exit
