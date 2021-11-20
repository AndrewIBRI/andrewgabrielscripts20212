#!/bin/bash
ls $2 > 1.log
ls $2 > 2.log
dirnumbers=$(ls $2 | wc -l)

while true ;do 

ls $2 > 2.log

if [ $(comm -3 -2 1.log 2.log | awk '{print $1}') ]; then
	dirnumbers2=$(ls $2 | wc -l)
    echo '[ '$(date +%d/%m/%Y)' '$(date +%H:%M:%S)' ] Alteração!' $dirnumbers'->'$dirnumbers2'. Removidos:' $(comm -3 -2 1.log 2.log) >> dirSensors.log
	dirnumbers=$(ls $2 | wc -l)
	ls $2 > 1.log	
fi

if [ $(comm -3 -1 1.log 2.log | awk '{print $1}') ]; then
	dirnumbers2=$(ls $2 | wc -l)
    echo '[ '$(date +%d/%m/%Y)' '$(date +%H:%M:%S)' ] Alteração!' $dirnumbers'->'$dirnumbers2'. Adicionados:' $(comm -3 -1 1.log 2.log) >> dirSensors.log
	dirnumbers=$(ls $2 | wc -l)
	ls $2 > 1.log
fi

sleep $1

done
