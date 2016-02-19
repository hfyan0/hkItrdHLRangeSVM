#!/bin/bash

SVMBINPATH=/home/qy/Dropbox/nirvana/svmlight/
# SVMBINPATH=/home/qy/Dropbox/nirvana/libsvm-3.20/
SYMBOLLIST="HSI HSCEI SHCOMP NKY KOSPI TWSE SENSEX DXY AUD NZD JPY EUR GBP CL1 GC1 DAX CAC UKX SPY VIX AS30 NZDOW VHSI"

#LOGFILE=/mnt/d/nir/svm_hsihlrange_$(date +'%Y%m%d_%H%M%S').log
LOGFILE=/mnt/d/nir/svm_hsihlrange_s.log
LOGTHETIMEFILE=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/log/logthetime_s

##########################################
SIMPLETEST_TRAINDATAFILE=svmregime_simpletest_train.txt
SIMPLETEST_TESTDATAFILE=svmregime_simpletest_test.txt
SIMPLETEST_THRESHOLD=0.02
SIMPLETEST_TRAINPERIOD=6000
SIMPLETEST_TESTPERIOD=1267

##########################################
BLMGDATAFOLDER=/home/qy/Dropbox/dataENF/blmg/data_adj/
PROCESSINGFOLDER=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/processing_s/
INPUTVECTORFOLDER=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_s/
INPUTVECTORPREFIX=svminputvec_

TRAINFOLDER=/mnt/d/nir/svm_hsihlrange_regime_train_s/
TESTFOLDER=/mnt/d/nir/svm_hsihlrange_regime_test_s/
TRAINFOLDERDEBUG=/mnt/d/nir/svm_hsihlrange_regime_train_debug_s/
TESTFOLDERDEBUG=/mnt/d/nir/svm_hsihlrange_regime_test_debug_s/

MODELFOLDER=/mnt/d/nir/svm_hsihlrange_regime_model_s/
PREDICTIONFOLDER=/mnt/d/nir/svm_hsihlrange_regime_predict_s/

COMPARERESULTFOLDER=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_s/
COMPARERESULTFILEPREFIX=comparison_
