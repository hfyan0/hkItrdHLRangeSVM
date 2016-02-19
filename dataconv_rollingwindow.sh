#!/bin/bash

if [[ $# -lt 3 ]]
then
    echo "arg: instance number"
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

INPUTFILE=$INPUTVECTORFOLDER/$INPUTVECTORPREFIX"$3"".txt"
NUMOFDAYSINTRAIN=$2

rm -f $TRAINFOLDER/* $TESTFOLDER/*
rm -f $TRAINFOLDERDEBUG/* $TESTFOLDERDEBUG/*


ALLDATES=$(cat $INPUTFILE | awk -F@ '{print $1}' | sort | uniq | tail -n +2)

for dt in $ALLDATES
do
    LINENUMBER=$(grep -n "^$dt" $INPUTFILE | head -1 | sed -e 's/:.*$//')
    echo $LINENUMBER

    dt=$(echo $dt | tr -d '-')
    echo $dt
    cat $INPUTFILE | head -n $(expr $LINENUMBER - 1) | grep -v 'NA' | tail -n $NUMOFDAYSINTRAIN > $TRAINFOLDERDEBUG/$dt
    cat $INPUTFILE | head -n $LINENUMBER | grep -v 'NA' | tail -1                               > $TESTFOLDERDEBUG/$dt
    cat $INPUTFILE | head -n $(expr $LINENUMBER - 1) | grep -v 'NA' | tail -n $NUMOFDAYSINTRAIN | sed -e 's/^.*@//' > $TRAINFOLDER/$dt
    cat $INPUTFILE | head -n $LINENUMBER | grep -v 'NA' | tail -1                               | sed -e 's/^.*@//' > $TESTFOLDER/$dt
done
