#!/bin/bash
# Correção: 1,0
mkdir cinco
for i in 1 2 3 4 5
do

	mkdir cinco/dir$i
	for x in 1 2 3 4
	do
		echo $x >> log.txt
		for line in $(cat log.txt)
		do
			echo $x >> cinco/dir$i/arq$x.txt
		done
		
	done
	rm log.txt
done
