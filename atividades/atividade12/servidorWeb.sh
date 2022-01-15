#!/bin/bash
echo "Criando servidor..."
aws ec2 run-instances --image-id ami-042e8287309f5df03 --instance-type "t2.micro" --key-name $1
ip= aws ec2 describe-instances --instance-ids {$(aws iam get-user --UserId)} --query 'Reservations[*].Instances[*].PublicIpAddress' --output text
echo $ip