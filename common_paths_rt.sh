#!/bin/bash

SVMBINPATH=/home/qy/Dropbox/nirvana/svmlight/
# SVMBINPATH=/home/qy/Dropbox/nirvana/libsvm-3.20/
SYMBOLLIST="HSI HSCEI SHCOMP NKY KOSPI TWSE SENSEX DXY AUD NZD JPY EUR GBP CL1 GC1 DAX CAC UKX SPY VIX AS30 NZDOW VHSI"
ASIANSYMBOLLIST="HSI HSCEI SHCOMP NKY KOSPI TWSE AUD NZD JPY AS30 NZDOW"

##########################################
LOGFILE=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/log//svm_hsihlrange_rt.log
LOGTHETIMEFILE=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/log/logthetime_rt

##########################################
REALTIME_TRAINDATAFILE=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/svmregime_realtime_train.txt
REALTIME_TESTDATAFILE=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/svmregime_realtime_test.txt
REALTIME_THRESHOLD="0.002 0.005 0.007 0.010 0.012 0.015 0.017 0.020 0.022 0.025 0.027 0.030 0.032 0.035 0.037 0.040 0.045 0.050 0.060"
REALTIME_TRAINPERIOD=252
REALTIME_TESTPERIOD=2
REALTIME_MODEL=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/svmregime_realtime_model.txt
REALTIME_PREDICTION=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/svmregime_realtime_prediction.txt

##########################################
BLMGDATAFOLDER=/home/qy/Dropbox/dataENF/blmg/data_adj/
PROCESSINGFOLDER=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/processing_rt/
INPUTVECTORFOLDER=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/
INPUTVECTORPREFIX=svminputvec_

COMPARERESULTFOLDER=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/
COMPARERESULTFILEPREFIX=comparison_
EXPECTEDHLRANGEOUTFILE_TDY=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/expectedhlrange_rt_tdy.txt
EXPECTEDHLRANGEOUTFILE_YTD=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/expectedhlrange_rt_ytd.txt
DATACOMPLETENESSSTATUSFILE=/home/qy/Dropbox/nirvana/hkItrdHLRangeSVM/results_rt/datacompletenessstatus
REALTIME_COMPAREFILE=$COMPARERESULTFILEPREFIX"_"$REALTIME_TRAINPERIOD

##########################################
# VHSIFILE=$BLMGDATAFOLDER/VHSI.csv
# VHSISUBSETFILE=$PROCESSINGFOLDER/VHSI_subset.csv
# VHSIARIMARESULT=$COMPARERESULTFOLDER/VHSI_arima_result.txt
