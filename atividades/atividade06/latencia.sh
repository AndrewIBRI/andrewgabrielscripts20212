#!/bin/bash
# Correção: 0,5
# Não há necessidade do sleep. Você deveria ter anexado ao arquivo para cada IP.
for line in $(cat $1)
do
	echo $line $(ping -c '10' -w '10' -q $line | grep avg | cut -c32-38) "ms" > lag.txt
	sleep 10
done
cat lag.txt
rm lag.txt
