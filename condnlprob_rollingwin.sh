#!/bin/bash

if [[ $# -eq 0]]
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

cd $COMPARERESULTFOLDER
for i in analysis_res*
do
    echo "____________________________"
    echo $i
    MPV=$(cat $i | awk '{print $2,$3}' | grep ^[0-9] | wc -l)
    echo "Model predicted volatile: $MPV"
    OV=$(cat $i | awk '{print $2,$3}' | grep ^[0-9] | awk '{print $2}' | grep +1 | wc -l)
    echo "Outcome volatile | Model predicted volatile: $OV"
    CP=$(echo $OV/$MPV\*100 | bc -l)
    echo "P(Outcome volatile | Model predicted volatile): $OV = $CP%"


    echo "____________________________"
    echo $i
    MPV=$(cat $i | awk '{print $2,$3}' | grep ^\-[0-9] | wc -l)
    echo "Model predicted not volatile: $MPV"
    OV=$(cat $i | awk '{print $2,$3}' | grep ^\-[0-9] | awk '{print $2}' | grep +1 | wc -l)
    echo "Outcome volatile | Model predicted not volatile: $OV"
    CP=$(echo $OV/$MPV\*100 | bc -l)
    echo "P(Outcome volatile | Model predicted not volatile): $OV = $CP%"

done


