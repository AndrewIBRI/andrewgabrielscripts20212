#!/bin/bash
# Correção: 0,5. Ganhou a presença, mas o script não executa. Também não instala o servidor web. A maneira com que a variável "ip" é declarada está errada.
echo "Criando servidor..."
aws ec2 run-instances --image-id ami-042e8287309f5df03 --instance-type "t2.micro" --key-name $1
ip= aws ec2 describe-instances --instance-ids {$(aws iam get-user --UserId)} --query 'Reservations[*].Instances[*].PublicIpAddress' --output text
echo $ip