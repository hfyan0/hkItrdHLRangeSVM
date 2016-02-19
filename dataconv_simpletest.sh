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

cat $INPUTVECTORFOLDER/$INPUTVECTORPREFIX"$SIMPLETEST_THRESHOLD"".txt" | head -n $SIMPLETEST_TRAINPERIOD | sed -e 's/^.*@//' | grep -v NA > $SIMPLETEST_TRAINDATAFILE
cat $INPUTVECTORFOLDER/$INPUTVECTORPREFIX"$SIMPLETEST_THRESHOLD"".txt" | tail -n $SIMPLETEST_TESTPERIOD  | sed -e 's/^.*@//' | grep -v NA > $SIMPLETEST_TESTDATAFILE
