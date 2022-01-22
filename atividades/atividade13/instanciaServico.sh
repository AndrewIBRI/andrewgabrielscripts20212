#!/bin/bash
subnet=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)
imagem=ami-042e8287309f5df03
grupid=$(aws ec2 describe-security-groups --query "SecurityGroups[0].GroupId" --output text)
aws ec2 run-instances --image-id $imagem --instance-type "t2.micro" --key-name $1 --security-group-ids $grupid --subnet-id $subnet --user-data file://configuracao.txt

sleep 5
ip=$(aws ec2 describe-instances --query "Reservations[].Instances[0].PublicIpAddress" --output text | awk  '{print $NF}')
echo "http://"$ip

