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

INPUTFILE=$INPUTVECTORFOLDER/$INPUTVECTORPREFIX"$2"".txt"

for rtthd in $REALTIME_THRESHOLD
do
    cat $INPUTFILE | sed -e 's/^.*@//' | grep -v NA | head -n -1 | tail -n $REALTIME_TRAINPERIOD > $REALTIME_TRAINDATAFILE
    cat $INPUTFILE | sed -e 's/^.*@//' | grep -v NA | tail -n $REALTIME_TESTPERIOD               > $REALTIME_TESTDATAFILE
done
