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

for i in 1000 100 10 1 0.1 0.01 0.001 0.0001 0.00001
do
     echo "-t 2: $i"
     $SVMBINPATH/svm_learn -v 0 -t 2 -g $i $SIMPLETEST_TRAINDATAFILE model
     $SVMBINPATH/svm_classify -v 1 $SIMPLETEST_TESTDATAFILE model predict
done

# for i in $(seq 0 3)
# do
#      echo "-t 1: $i"
#      echo "--------------------------------------------"
#      $SVMBINPATH/svm_learn -v 0 -t 1 -d $i $SIMPLETEST_TRAINDATAFILE model
#      $SVMBINPATH/svm_classify -v 1 $SIMPLETEST_TESTDATAFILE model predict
#
# done
#
#      echo "--------------------------------------------"
#      $SVMBINPATH/svm_learn -v 0 -t 0 $SIMPLETEST_TRAINDATAFILE model
#      $SVMBINPATH/svm_classify -v 1 $SIMPLETEST_TESTDATAFILE model predict
#
#      # echo "--------------------------------------------"
#      # $SVMBINPATH/svm_learn -v 0 -t 3 $SIMPLETEST_TRAINDATAFILE model
#      # $SVMBINPATH/svm_classify -v 1 $SIMPLETEST_TESTDATAFILE model predict
