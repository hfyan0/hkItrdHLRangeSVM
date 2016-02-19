#!/bin/bash

if [[ $# -eq 0 ]]
then
    echo "arg : instance number"
    exit
fi

INSTANCENO=$1

if [[ ! -f "common_paths_"$INSTANCENO".sh" ]]
then
    echo "Can't find common_paths.sh"
    exit
fi

source "common_paths_"$INSTANCENO".sh"
#########################################################

TODAYSTR=$(date +"%Y-%m-%d")

echo "Data completeness check."

DATACOMPLETE="Y"

for sym in $ASIANSYMBOLLIST
do
    sym=$sym".csv"
    if [[ $(cat $BLMGDATAFOLDER/$sym | grep $TODAYSTR | wc -l) -eq 0 ]]
    then
        echo "Missing data $TODAYSTR: " $sym
        tail -3 $BLMGDATAFOLDER/$sym
        DATACOMPLETE="N"
    else
        echo "Data OK: " $sym
    fi
done

echo $DATACOMPLETE > $DATACOMPLETENESSSTATUSFILE
