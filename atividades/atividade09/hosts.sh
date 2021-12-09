#!/bin/bash
# Correção: 0,5. 
comando1=$1
host=$2
comando2=$3
ip=$4

while getopts "adlr" OPTVAR
do
	case $OPTVAR in
		a)
			if [ $comando2 == '-i' ] ; then
				echo "$host	$ip" >> hosts.db
			fi
			;;
		l)
			cat hosts.db
			;;
		r)
			grep $2 hosts.db | cut -f1
			;;
		d)
			sed -i '/'$host'/d' hosts.db
			;;
		*)
			;;
	esac

done
case $comando1 in
		$1)
			grep $2 hosts.db | cut -f2
			;;
esac
