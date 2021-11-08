#!/bin/bash
# Correção: 0,5
a=$1
b=$2
c=$3

if [$a -eq $a] 2>/dev/null;then
	echo $a 'Opa!!! $a não é número'
elif [$b -eq $b] 2>/dev/null;then
	echo $b 'Opa!!! $b não é número'
elif [$c -eq $c] 2>/dev/null;then
	echo $c 'Opa!!! $c não é número'
else
	if [ $a -gt $b -a $a -gt $c ] 2>/dev/null ; then
		echo $a ' e o maior numero'
	elif [ $b -gt $c ] 2>/dev/null ; then
		echo $b ' e o maior numero'
	else
		echo $c ' e o maior numero'
	fi
fi
