#!/bin/bash
comando=$1
nome=$2
email=$3

case $comando in
	adicionar)
		if [ -f agenda.db ];then
			true
		else
			echo "Arquivo criado!!!"
		fi
		echo $nome:$email >> agenda.db
		echo "Usuário $nome adicionado."
		;;
	listar)
		if [ -f agenda.db ];then
			cat usuarios.db
		else
			echo "Arquivo vazio!!!"
		fi
		
		;;
	remover)
		if [ -z $(grep '$2' agenda.db) ];then
			echo "Arquivo inalterado!!!"
		else
			sed -i '/'$2'/d' agenda.db
			echo "Usuário $2 removido."
		fi
		;;
esac
