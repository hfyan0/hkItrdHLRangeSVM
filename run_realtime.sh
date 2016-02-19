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

dt=$(date +"%Y%m%d")
$SVMBINPATH/svm_learn -v 0 -t 2 -g 1 $REALTIME_TRAINDATAFILE $REALTIME_MODEL
$SVMBINPATH/svm_classify -v 1 $REALTIME_TESTDATAFILE $REALTIME_MODEL $REALTIME_PREDICTION
