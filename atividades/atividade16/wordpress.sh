#!/bin/bash
# Correção: 1,5. Por que você cria uma instância RDS aqui?!? Na Atividade 16, era para criar uma instância EC2 e instalar o servidor de banco de dados nela. 
ipdohost=$(curl ifconfig.me)
if [ -z $1 ] ; then
echo "Nome da chave nao inserida"
exit
fi
usuario='"$2"'@'%'
sed -i '2s/^/usuario='$2'\n/' mq1.txt
sed -i '3s/^/senha='$3'\n/' mq1.txt
sed -i '34s/^/USER='$2'\n/' mq2.txt
sed -i '35s/^/PASSWORD='$3'\n/' mq2.txt
pending=true
subnet=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
imagem=ami-04505e74c0741db8d
grupid=$(aws ec2 create-security-group --group-name andrew --description "atividade16mysql" --output text)
aws ec2 authorize-security-group-ingress --group-name andrew --port 22 --protocol tcp --cidr $ipdohost/0 >/dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-name andrew --port 80 --protocol tcp --cidr 0.0.0.0/0 >/dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-name andrew --port 3306 --protocol tcp --source-group $grupid >/dev/null 2>&1
aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --key-name $1 --security-group-ids $grupid --subnet-id $subnet --user-data file://mq1.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=bancodedados}]' >/dev/null 
aws rds create-db-instance --db-instance-identifier test-mysql-instance --db-instance-class db.t2.micro --engine mysql --master-username admin --master-user-password secret99 --allocated-storage 20 
while [ $pending == true ]
do
echo "Criando servidor de Banco de Dados..."
   if [ $(aws ec2 describe-instances --filters 'Name=tag:Name,Values=bancodedados'   --output text --query 'Reservations[].Instances[].[State.Name]') == "running" ]; then
   pending=false
   ip1=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=bancodedados'   --output text --query 'Reservations[].Instances[].PrivateIpAddress')
   fi
done

echo "IP Privado do Banco de Dados:"$ip1
sed -i '36s/^/HOST='$ip1'\n/' mq2.txt

pending=true
#possiveis erros com a instalacao do mysql mas eu coloquei o sleep pra certificar que estaria tudo ok antes de iniciar a 2 estancia
echo "Esperando 20 segundos para inicializar Segundo servidor(para dar tempo de instalar o mysql server)"

sleep 20

aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --key-name $1 --security-group-ids $grupid --subnet-id $subnet --user-data file://mq2.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=aplicacao}]' >/dev/null 

while [ $pending == true ]
do
echo "Criando servidor de Aplicação..."
   if [ $(aws ec2 describe-instances --filters 'Name=tag:Name,Values=aplicacao'   --output text --query 'Reservations[].Instances[].[State.Name]') == "running" ]; then
   pending=false
   ip2=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=aplicacao'   --output text --query 'Reservations[].Instances[].PublicIpAddress')
   fi
done

echo "IP Público do Servidor de Aplicação:"$ip2
echo "Acesse http://"$ip2"/wordpress para finalizar a configuração."
