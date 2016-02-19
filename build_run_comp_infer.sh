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


if [[ ! -d $PROCESSINGFOLDER         ]]; then mkdir $PROCESSINGFOLDER      ; fi
if [[ ! -d $INPUTVECTORFOLDER        ]]; then mkdir $INPUTVECTORFOLDER     ; fi
if [[ ! -d $COMPARERESULTFOLDER      ]]; then mkdir $COMPARERESULTFOLDER   ; fi

if [[ ! -z $TRAINFOLDER        && ! -d $TRAINFOLDER              ]]; then mkdir $TRAINFOLDER           ; fi
if [[ ! -z $TESTFOLDER         && ! -d $TESTFOLDER               ]]; then mkdir $TESTFOLDER            ; fi
if [[ ! -z $TRAINFOLDERDEBUG   && ! -d $TRAINFOLDERDEBUG         ]]; then mkdir $TRAINFOLDERDEBUG      ; fi
if [[ ! -z $TESTFOLDERDEBUG    && ! -d $TESTFOLDERDEBUG          ]]; then mkdir $TESTFOLDERDEBUG       ; fi
if [[ ! -z $MODELFOLDER        && ! -d $MODELFOLDER              ]]; then mkdir $MODELFOLDER           ; fi
if [[ ! -z $PREDICTIONFOLDER   && ! -d $PREDICTIONFOLDER         ]]; then mkdir $PREDICTIONFOLDER      ; fi


#############
# Simple test
#############
if [[ $INSTANCENO == "s" || $INSTANCENO == "simple" ]]
then
    hsit=$SIMPLETEST_THRESHOLD
    echo -n "1  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./extract_features.sh     $INSTANCENO >> $LOGFILE
    echo -n "2  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./build_input_vector.py   $PROCESSINGFOLDER $INPUTVECTORFOLDER $INPUTVECTORPREFIX $hsit >> $LOGFILE
    echo -n "3  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./dataconv_simpletest.sh  $INSTANCENO   >> $LOGFILE
    echo -n "4  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./run_simple_test.sh      $INSTANCENO   >> $LOGFILE
    echo -n "6  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE;
    exit
fi


#############
# Real time
#############
if [[ $INSTANCENO == "rt" || $INSTANCENO == "realtime" ]]
then
    echo "--------------------------------------------------" >  $LOGFILE
    date                                                      >> $LOGFILE
    echo "--------------------------------------------------" >> $LOGFILE
    # echo -n "a  "         >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./vhsi_arima.sh                 $INSTANCENO $REALTIME_TRAINPERIOD                             >> $LOGFILE

    for hsit in $REALTIME_THRESHOLD
    do
        echo -n "0  "     >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./datachk_realtime.sh           $INSTANCENO                                                   >> $LOGFILE
        if [[ $(cat $DATACOMPLETENESSSTATUSFILE | grep Y | wc -l) -eq 1 ]]
        then
            echo -n "1  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./extract_features.sh           $INSTANCENO                                                   >> $LOGFILE
            echo -n "2  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./build_input_vector.py         $PROCESSINGFOLDER $INPUTVECTORFOLDER $INPUTVECTORPREFIX $hsit >> $LOGFILE
            echo -n "3  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./dataconv_realtime.sh          $INSTANCENO                                             $hsit >> $LOGFILE
            echo -n "4  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./run_realtime.sh               $INSTANCENO                                                   >> $LOGFILE
            echo -n "5  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./compare_realtime.sh           $INSTANCENO $REALTIME_TRAINPERIOD                       $hsit >> $LOGFILE
            echo -n "5  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./infer_svm_hlrange_realtime.sh $INSTANCENO                                                   >> $LOGFILE
            echo -n "6  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE;
        else
            date >> $LOGFILE; echo "Shit. Some data is not up-to-date. Aborting..." >> $LOGFILE;
        fi
    done
    exit
fi


#############
echo "________________________________" > $LOGTHETIMEFILE
echo "New run:" >> $LOGTHETIMEFILE


#############
for hsit in $HLTHRESHOLD
do
    for rollprd in $TRAINPERIOD
    do
       # echo -n "a  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./vhsi_arima.sh $INSTANCENO $rollprd >> $LOGFILE
       echo -n "1  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./extract_features.sh $INSTANCENO >> $LOGFILE
       echo -n "2  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./build_input_vector.py $PROCESSINGFOLDER $INPUTVECTORFOLDER $INPUTVECTORPREFIX $hsit >> $LOGFILE

       echo -n "3  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./dataconv_rollingwindow.sh $INSTANCENO $rollprd $hsit >> $LOGFILE
       echo -n "4  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./run_rollingwindow.sh      $INSTANCENO                >> $LOGFILE
       echo -n "5  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE; ./compare_rollingwin.sh     $INSTANCENO $rollprd $hsit >> $LOGFILE
       echo -n "6  " >> $LOGTHETIMEFILE; date >> $LOGTHETIMEFILE;
    done
done

