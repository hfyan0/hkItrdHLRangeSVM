#!/bin/bash

SVMBINPATH=/home/qy/Dropbox/nirvana/svmlight/
# SVMBINPATH=/home/qy/Dropbox/nirvana/libsvm-3.20/
SYMBOLLIST="HSI HSCEI SHCOMP NKY KOSPI TWSE SENSEX DXY AUD NZD JPY EUR GBP CL1 GC1 DAX CAC UKX SPY VIX AS30 NZDOW VHSI"

#LOGFILE=/mnt/d/nir/svm_hsihlrange_$(date +'%Y%m%d_%H%M%S').log
LOGFILE=/mnt/d/nir/svm_hsihlrange_2.log
LOGTHETIMEFILE=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/log/logthetime_2

##########################################
#TRAINPERIOD="0005 0044 0252 1008 2520"
TRAINPERIOD="0756"
HLTHRESHOLD="0.002 0.005 0.007 0.010 0.012 0.015 0.017 0.020 0.022 0.025 0.027 0.030 0.032 0.035 0.037 0.040 0.045 0.050 0.060"

##########################################
BLMGDATAFOLDER=/home/qy/Dropbox/dataENF/blmg/data_adj/
PROCESSINGFOLDER=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/processing_2/
INPUTVECTORFOLDER=/mnt/d/nir/svm_hsihlrange_results_2/
INPUTVECTORPREFIX=svminputvec_

TRAINFOLDER=/mnt/d/nir/svm_hsihlrange_regime_train_2/
TESTFOLDER=/mnt/d/nir/svm_hsihlrange_regime_test_2/
TRAINFOLDERDEBUG=/mnt/d/nir/svm_hsihlrange_regime_train_debug_2/
TESTFOLDERDEBUG=/mnt/d/nir/svm_hsihlrange_regime_test_debug_2/

MODELFOLDER=/mnt/d/nir/svm_hsihlrange_regime_model_2/
PREDICTIONFOLDER=/mnt/d/nir/svm_hsihlrange_regime_predict_2/

COMPARERESULTFOLDER=/mnt/d/nir/svm_hsihlrange_results_2/
COMPARERESULTFILEPREFIX=comparison_
EXPECTEDHLRANGEOUTFILE=/mnt/d/nir/svm_hsihlrange_results_2/expectedhlrange_2.txt
BKTEST_COMPAREFILE=$COMPARERESULTFILEPREFIX"_"$TRAINPERIOD

##########################################
# VHSIFILE=$BLMGDATAFOLDER/VHSI.csv
# VHSISUBSETFILE=$PROCESSINGFOLDER/VHSI_subset.csv
# VHSIARIMARESULT=$COMPARERESULTFOLDER/VHSI_arima_result.txt
