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

TMPFILE=/tmp/vhsi_arima_tmp
TMPFILE2=/tmp/vhsi_arima_tmp_2
VHSIFILELEN=$(cat $VHSIFILE | wc -l)
VHSITRAINPERIOD=$2

rm -f $VHSIARIMARESULT

for i in $(seq 1 $VHSIFILELEN)
do
    if [[ $i -lt $VHSITRAINPERIOD ]]
    then
        continue
    fi

    if [[ $INSTANCENO == "rt" && $i -ne $VHSIFILELEN ]]
    then
        continue
    fi

    cat $VHSIFILE | head -n $i | tail -n $VHSITRAINPERIOD | awk -F, '{print $3}' > $VHSISUBSETFILE

    cat $VHSIFILE | head -n $i | tail -n $VHSITRAINPERIOD | tail -1 | awk -F, '{print $1}' >> $VHSIARIMARESULT

    echo @ >> $VHSIARIMARESULT
    Rscript vhsi_arima.R $VHSISUBSETFILE | tr '\n' ' ' | awk '{OFS="@"; print $2,$4,$6,$8,$10,$12,$14}' >> $VHSIARIMARESULT
    echo _ >> $VHSIARIMARESULT
done

cat $VHSIARIMARESULT | tr -d '\n' | tr '@' ',' | tr '_' '\n' > $TMPFILE
mv -f $TMPFILE $VHSIARIMARESULT

#########################################################
# Back fill missing data
#########################################################
cat $VHSIFILE | awk -F, '{print $1}' > $TMPFILE
cat $VHSIARIMARESULT | awk 'length>17' | awk -F, '{print $1}' > $TMPFILE2
DATESMISSINGARIMA=$(diff $TMPFILE $TMPFILE2 | egrep '^>|^<' | cut -c3-1000 | sort)
echo $DATESMISSINGARIMA
for i in $DATESMISSINGARIMA
do
    cat $VHSIFILE | grep ^$i | awk -F, 'BEGIN{OFS=","}{print $1,0,0,0,0,0,0,$6}' >> $VHSIARIMARESULT
done
cat $VHSIARIMARESULT | awk 'length>17' | sort | uniq > $TMPFILE
mv -f $TMPFILE $VHSIARIMARESULT

rm -f $VHSISUBSETFILE
rm -f $TMPFILE $TMPFILE2
