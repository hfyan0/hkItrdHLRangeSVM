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

TMPFILE=/tmp/extract_features.tmp
rm -f $PROCESSINGFOLDER/*

for i in $SYMBOLLIST
do
    cat "$BLMGDATAFOLDER/$i".csv | awk -F, 'BEGIN{OFS=","; lastopen=0; lastclose=0; lastavg=0}{if(lastopen>0 && lastclose>0 && lastavg>0) print $1,($4-$5)/$3,log($6/lastclose),log($3/lastclose),log($3/(lastavg)); else print $1,($4-$5)/$3,0,0,0; lastopen=$3; lastclose=$6; lastavg=($3+$4+$5+$6)/4;}' > $TMPFILE
    mv -f $TMPFILE "$PROCESSINGFOLDER/$i".csv
done

# #########################################################
# # VHSI arima
# #########################################################
# cat $VHSIARIMARESULT | awk -F, 'BEGIN{OFS=","; lastprediction=0}{if(lastprediction>0) print $1,0,lastprediction,lastprediction,lastprediction; else print $1,0,0,0,0; lastprediction=$8}' > $TMPFILE
# mv -f $TMPFILE $PROCESSINGFOLDER/"VHSI.csv"

fromdos $PROCESSINGFOLDER/*
