#!/bin/bash

if [[ $# -lt 3 ]]
then
    echo "arg: instance no"
    echo "arg: rolling window period"
    echo "arg: threshold"
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

COMPARERESULTFILE=$COMPARERESULTFOLDER/$COMPARERESULTFILEPREFIX"_"$2"_"$3".txt"

rm -f $COMPARERESULTFILE

paste -d'\t' $REALTIME_PREDICTION $REALTIME_TESTDATAFILE >> $COMPARERESULTFILE
