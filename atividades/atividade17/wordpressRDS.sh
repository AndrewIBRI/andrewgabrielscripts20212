#!/bin/bash
ipdohost=$(curl ifconfig.me)
if [ -z $1 ] ; then
echo "Nome da chave nao inserida"
exit
fi
usuario='"$2"'@'%'
sed -i '2s/^/usuario='$2'\n/' mq2.txt
sed -i '3s/^/senha='$3'\n/' mq2.txt
sed -i '4s/^/USER='$2'\n/' mq2.txt
sed -i '5s/^/PASSWORD='$3'\n/' mq2.txt
pending=true
subnet=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
imagem=ami-04505e74c0741db8d
grupid=$(aws ec2 create-security-group --group-name wordpressrds --description "atividade15mysql" --output text)
aws ec2 authorize-security-group-ingress --group-name wordpressrds --port 22 --protocol tcp --cidr $ipdohost/0 >/dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-name wordpressrds --port 80 --protocol tcp --cidr 0.0.0.0/0 >/dev/null 2>&1
aws ec2 authorize-security-group-ingress --group-name wordpressrds --port 3306 --protocol tcp --source-group $grupid >/dev/null 2>&1
aws rds create-db-instance --db-instance-identifier wordpressrdsdb --vpc-security-group-ids $grupid --db-instance-class db.t2.micro --engine mysql --master-username $2 --master-user-password $3 --allocated-storage 20 >/dev/null 

while [ $pending == true ]
do
echo "Criando servidor de Banco de Dados..."
   if [ $(aws rds describe-db-instances --output text --query "DBInstances[].DBInstanceStatus") == "available" ]; then
   pending=false
   ip1=$(aws rds describe-db-instances --output text --query "DBInstances[].Endpoint[].Address")
   fi
   sleep 5
done

echo "Endpoint do RDS:"$ip1
sed -i '3s/^/HOST='$ip1'\n/' mq2.txt

pending=true
#possiveis erros com a instalacao do mysql mas eu coloquei o sleep pra certificar que estaria tudo ok antes de iniciar a 2 estancia
echo "Esperando 20 segundos para inicializar Segundo servidor(para dar tempo de instalar o mysql server)"

sleep 20

aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --key-name $1 --security-group-ids $grupid --subnet-id $subnet --user-data file://mq2.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=aplicacaoweb}]' >/dev/null 

while [ $pending == true ]
do
echo "Criando servidor de Aplicação..."
   if [ $(aws ec2 describe-instances --filters 'Name=tag:Name,Values=aplicacaoweb'   --output text --query 'Reservations[].Instances[].[State.Name]') == "running" ]; then
   pending=false
   ip2=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=aplicacaoweb'   --output text --query 'Reservations[].Instances[].PublicIpAddress')
   fi
   sleep 5
done

echo "IP Público do Servidor de Aplicação:"$ip2
echo "Acesse http://"$ip2"/wordpress para finalizar a configuração."
