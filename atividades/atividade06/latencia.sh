#!/bin/bash
for line in $(cat $1)
do
	echo $line $(ping -c '10' -w '10' -q $line | grep avg | cut -c32-38) "ms" > lag.txt
	sleep 10
done
cat lag.txt
rm lag.txt