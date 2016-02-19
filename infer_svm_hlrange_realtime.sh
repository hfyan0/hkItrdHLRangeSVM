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
TMPFILE1=/tmp/infer_expected_hlrange_tmp1_$(date +'%s')
TMPFILE2=/tmp/infer_expected_hlrange_tmp2_$(date +'%s')

cd $COMPARERESULTFOLDER

rm -rf $TMPFILE1 $TMPFILE2
touch $TMPFILE1 $TMPFILE2

for lin in 1 2
do
    rm -rf $TMPFILE1 $TMPFILE2
    touch $TMPFILE1 $TMPFILE2

    for i in $REALTIME_COMPAREFILE*
    do
        cat $i | awk '{print $1}' | tail -n $lin | head -1 >> $TMPFILE1
    done
    
    for i in $REALTIME_THRESHOLD
    do
        echo $i >> $TMPFILE2
    done

    if   [[ $lin -eq 1 ]]
    then
        paste -d" " $TMPFILE2 $TMPFILE1 > $EXPECTEDHLRANGEOUTFILE_TDY
    elif [[ $lin -eq 2 ]]
    then
        paste -d" " $TMPFILE2 $TMPFILE1 > $EXPECTEDHLRANGEOUTFILE_YTD
    fi
done

SVMPREDICTEDRANGE_TDY=$(cat $EXPECTEDHLRANGEOUTFILE_TDY | awk 'BEGIN{lastthreshold=0;lastsvmprediction=0}{if((lastsvmprediction!=0) && (lastsvmprediction*$2<0)) print ($1+lastthreshold)/2; lastthreshold=$1; lastsvmprediction=$2;}')
SVMPREDICTEDRANGE_YTD=$(cat $EXPECTEDHLRANGEOUTFILE_YTD | awk 'BEGIN{lastthreshold=0;lastsvmprediction=0}{if((lastsvmprediction!=0) && (lastsvmprediction*$2<0)) print ($1+lastthreshold)/2; lastthreshold=$1; lastsvmprediction=$2;}')

echo "SVM predicted HSI HL range: TDY: $SVMPREDICTEDRANGE_TDY"
echo "SVM predicted HSI HL range: YTD: $SVMPREDICTEDRANGE_YTD"

LATESTVHSISTRING=$(cat $BLMGDATAFOLDER/VHSI.csv | tail -1)
LATESTVHSI100=$(echo $LATESTVHSISTRING | awk -F, '{print $1}')
VHSI_YTD1=$(echo $(echo $LATESTVHSISTRING | awk -F, '{print $3}')" / 100" | bc -l)
LATESTVHSISTRING_1=$(cat $BLMGDATAFOLDER/VHSI.csv | tail -2 | head -1)
LATESTVHSI100_1=$(echo $LATESTVHSISTRING_1 | awk -F, '{print $1}')
VHSI_YTD2=$(echo $(echo $LATESTVHSISTRING_1 | awk -F, '{print $3}')" / 100" | bc -l)
echo "VHSI YTD1: $VHSI_YTD1"
echo "VHSI YTD2: $VHSI_YTD2"

VHSIINC=$(echo "$VHSI_YTD1 > $VHSI_YTD2" | bc -l)
SVMINC=$(echo "$SVMPREDICTEDRANGE_TDY > $SVMPREDICTEDRANGE_YTD" | bc -l)

PREDICTEDHSIHLRANGE=$(echo "0.003289555 + 0.307879913 * $SVMPREDICTEDRANGE_TDY + 0.037031622 * $VHSI_YTD1 * $VHSI_YTD1 + 0.028291717 * $VHSI_YTD1 + 0.001779129 * $SVMINC + 1.842618215 * $VHSIINC * ($VHSI_YTD1 - $VHSI_YTD2) * ($VHSI_YTD1 - $VHSI_YTD2)" | bc -l )
echo "E[VHSI] = $PREDICTEDHSIHLRANGE"

rm -rf $TMPFILE1 $TMPFILE2
