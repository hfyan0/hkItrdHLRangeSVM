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
TMPFOLDER=/tmp/infer_expected_hlrange_tmp_$(date +'%s')/

rm -rf $TMPFOLDER
mkdir $TMPFOLDER

cd $COMPARERESULTFOLDER
for i in $BKTEST_COMPAREFILE*
do
    cat $i | awk '{print $1}' > $TMPFOLDER/alldates
    break
done

# cat $TMPFOLDER/alldates

for i in $BKTEST_COMPAREFILE*
do
    cat $i | awk '{print $2}' > $TMPFOLDER/$i
done

paste $TMPFOLDER/alldates $TMPFOLDER/$BKTEST_COMPAREFILE* > $EXPECTEDHLRANGEOUTFILE

rm -rf $TMPFOLDER
