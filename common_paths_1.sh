#!/bin/bash

SVMBINPATH=/home/qy/Dropbox/nirvana/svmlight/
# SVMBINPATH=/home/qy/Dropbox/nirvana/libsvm-3.20/
SYMBOLLIST="HSI HSCEI SHCOMP NKY KOSPI TWSE SENSEX DXY AUD NZD JPY EUR GBP CL1 GC1 DAX CAC UKX SPY VIX AS30 NZDOW VHSI"

#LOGFILE=/mnt/d/nir/svm_hsihlrange_$(date +'%Y%m%d_%H%M%S').log
LOGFILE=/mnt/d/nir/svm_hsihlrange_1.log
LOGTHETIMEFILE=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/log/logthetime_1

##########################################
TRAINPERIOD="0252"
HLTHRESHOLD="0.002 0.005 0.007 0.010 0.012 0.015 0.017 0.020 0.022 0.025 0.027 0.030 0.032 0.035 0.037 0.040 0.045 0.050 0.060"

##########################################
BLMGDATAFOLDER=/home/qy/Dropbox/dataENF/blmg/data_adj/
PROCESSINGFOLDER=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/processing_1/
INPUTVECTORFOLDER=/mnt/d/nir/svm_hsihlrange_results_1/
INPUTVECTORPREFIX=svminputvec_

TRAINFOLDER=/mnt/d/nir/svm_hsihlrange_regime_train_1/
TESTFOLDER=/mnt/d/nir/svm_hsihlrange_regime_test_1/
TRAINFOLDERDEBUG=/mnt/d/nir/svm_hsihlrange_regime_train_debug_1/
TESTFOLDERDEBUG=/mnt/d/nir/svm_hsihlrange_regime_test_debug_1/

MODELFOLDER=/mnt/d/nir/svm_hsihlrange_regime_model_1/
PREDICTIONFOLDER=/mnt/d/nir/svm_hsihlrange_regime_predict_1/

COMPARERESULTFOLDER=/mnt/d/nir/svm_hsihlrange_results_1/
COMPARERESULTFILEPREFIX=comparison_
EXPECTEDHLRANGEOUTFILE=/mnt/d/nir/svm_hsihlrange_results_1/expectedhlrange_1.txt
BKTEST_COMPAREFILE=$COMPARERESULTFILEPREFIX"_"$TRAINPERIOD

##########################################
# VHSIFILE=$BLMGDATAFOLDER/VHSI.csv
# VHSISUBSETFILE=$PROCESSINGFOLDER/VHSI_subset.csv
# VHSIARIMARESULT=$COMPARERESULTFOLDER/VHSI_arima_result.txt
