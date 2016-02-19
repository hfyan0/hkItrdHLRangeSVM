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

rm -f $TRAINFOLDER/core*
rm -f $MODELFOLDER/* $PREDICTIONFOLDER/*

cd $TRAINFOLDER
for dt in $(ls | grep -v model)
do
    echo $dt
    # SVMLIGHT
    $SVMBINPATH/svm_learn -v 1 -t 2 -g 1 $TRAINFOLDER/$dt $MODELFOLDER/$dt
    $SVMBINPATH/svm_classify -v 1 $TESTFOLDER/$dt $MODELFOLDER/$dt $PREDICTIONFOLDER/$dt

    # # LIBSVM
    # $SVMBINPATH/svm-train -s 3 -t 2 -g 1 -b 1 $TRAINFOLDER/$dt
    # mv $TRAINFOLDER/$dt".model" $MODELFOLDER/$dt".model"
    # $SVMBINPATH/svm-predict $TESTFOLDER/$dt $MODELFOLDER/$dt".model" $PREDICTIONFOLDER/$dt
done
