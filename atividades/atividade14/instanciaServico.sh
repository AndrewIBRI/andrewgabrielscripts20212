#!/bin/bash
if [ -z $1 ] ; then
echo "Nome da chave nao inserida"
exit
fi

pending=true
subnet=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
imagem=ami-04505e74c0741db8d
grupid=$(aws ec2 create-security-group --group-name andrew --description "atividade14webccron" --output text)
aws ec2 authorize-security-group-ingress --group-name andrew --port 80 --protocol tcp --cidr 0.0.0.0/0 >/dev/null 2>&1
aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --key-name $1 --security-group-ids $grupid --subnet-id $subnet --user-data file://configuracao.txt --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=andrew}]' >/dev/null 

while [ $pending == true ]
do
echo "inicializando aguarde..."
   if [ $(aws ec2 describe-instances --filters 'Name=tag:Name,Values=andrew'   --output text --query 'Reservations[*].Instances[*].[State.Name]') == "running" ]; then
   pending=false
   ip=$(aws ec2 describe-instances --filters 'Name=tag:Name,Values=andrew'   --output text --query 'Reservations[*].Instances[*].PublicIpAddress')
   fi
done

echo "http://"$ip
