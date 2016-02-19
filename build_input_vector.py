#!/usr/bin/python

from os import listdir
from os.path import isfile, join
import datetime
import time
import socket
import thread
from threading import Thread
from inspect import currentframe, getframeinfo
import sys
import signal
import inspect

'''
Param
'''
DEBUGMODE=False
FEATUREFOLDER=sys.argv[1]
SVMTRAININGDATAFILE=sys.argv[2]+"/"+sys.argv[3]+sys.argv[4]+".txt"
THRESHOLD=float(sys.argv[4])

SUBJECTSYMBOL="HSI.csv"

SYMBOLLISTASIAN=set()
SYMBOLLISTASIAN.add("HSI.csv")
SYMBOLLISTASIAN.add("HSCEI.csv")
SYMBOLLISTASIAN.add("VHSI.csv")
SYMBOLLISTASIAN.add("SHCOMP.csv")
SYMBOLLISTASIAN.add("NKY.csv")
SYMBOLLISTASIAN.add("KOSPI.csv")
SYMBOLLISTASIAN.add("TWSE.csv")
SYMBOLLISTASIAN.add("AS30.csv")
SYMBOLLISTASIAN.add("NZDOW.csv")


DRIVER_SYMBOLS_WITHCSV = [ f for f in listdir(FEATUREFOLDER) if isfile(join(FEATUREFOLDER,f)) ]

if DEBUGMODE==True:
    print DRIVER_SYMBOLS_WITHCSV

lolol_extracted_features_raw=[]
list_hlrangepctg_subj_aligned=[]
molol_input_features_vec_aligned={}
set_of_alldates_int=set()

####################################
# read feature data
####################################
for drvr in DRIVER_SYMBOLS_WITHCSV:
    with open(FEATUREFOLDER+"/"+drvr, 'r+') as f:
        csvstrings = f.readlines()
        csvlol = []
        for i in range(0,len(csvstrings)):
            csvlist = csvstrings[i].strip().split(',')
            csvlist[0]=int(csvlist[0].replace("-",""))
            set_of_alldates_int.add(csvlist[0])
            csvlist[1]=float(csvlist[1])
            csvlist[2]=float(csvlist[2])
            csvlist[3]=float(csvlist[3])
            csvlist[4]=float(csvlist[4])
            csvlol.append(csvlist)
        lolol_extracted_features_raw.append(csvlol)

set_of_alldates_int=sorted(set_of_alldates_int)
list_of_alldates_int=list(set_of_alldates_int)

if DEBUGMODE == True:
    print lolol_extracted_features_raw
    print set_of_alldates_int


####################################
# align for y
####################################
for iSym in range(0,len(DRIVER_SYMBOLS_WITHCSV)):
    if SUBJECTSYMBOL != DRIVER_SYMBOLS_WITHCSV[iSym]:
        continue
    iLineNoInRawExtrFea = 0
    rawdateinint_cur=0
    for oneinalldates in set_of_alldates_int:
        rawdateinint_cur=lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea][0]
        if oneinalldates == rawdateinint_cur:
            list_hlrangepctg_subj_aligned.append(lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea][1])
            iLineNoInRawExtrFea = iLineNoInRawExtrFea + 1
            # print oneinalldates
        elif oneinalldates < rawdateinint_cur:
            list_hlrangepctg_subj_aligned.append("NA")
        else:
            print "ERROR: " + inspect.currentframe().f_back.f_lineno + DRIVER_SYMBOLS_WITHCSV[iSym] + " " + oneinalldates + " " + rawdateinint_cur
            sys.exit(1)



####################################
# align data for x, input vector, asian markets
####################################
na_fea_list2=[]
na_fea_list2.append("SYM")
na_fea_list2.append(0)
na_fea_list2.append(0)
na_fea_list2.append(0)
for iSym in range(0,len(DRIVER_SYMBOLS_WITHCSV)):
    iLineNoInRawExtrFea = 0

    lol_drvr_fea_vec=[]
    rawdateinint_prev=0
    rawdateinint_cur=0
    for oneinalldates in set_of_alldates_int:
        if iLineNoInRawExtrFea >= len(lolol_extracted_features_raw[iSym]):
            na_fea_list=[]
            na_fea_list.append(oneinalldates)
            na_fea_list.append(0)
            na_fea_list.append(0)
            na_fea_list.append(0)
            na_fea_list.append(0)
            lolol_extracted_features_raw[iSym].append(na_fea_list)

        rawdateinint_prev=rawdateinint_cur
        rawdateinint_cur=lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea][0]
        cond1=(oneinalldates == rawdateinint_cur)
        cond2=(oneinalldates < rawdateinint_cur) and (oneinalldates > rawdateinint_prev)
        if cond1 or cond2:
            cur_fea_vec=[]

            cur_fea_vec.append(lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea][0])
            if (str(DRIVER_SYMBOLS_WITHCSV[iSym]) in SYMBOLLISTASIAN):
                # Yesterday HLRangePctg, Today C-O, Today A-O
                cur_fea_vec.append(lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea-1][1])
                cur_fea_vec.append(lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea][3])
                cur_fea_vec.append(lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea][4])
            else:
                # Yesterday HLRangePctg, Yesterday C-C, Yesterday C-O
                cur_fea_vec.append(lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea-1][1])
                cur_fea_vec.append(lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea-1][2])
                cur_fea_vec.append(lolol_extracted_features_raw[iSym][iLineNoInRawExtrFea-1][3])

            lol_drvr_fea_vec.append(cur_fea_vec)
            if cond1:
                iLineNoInRawExtrFea = iLineNoInRawExtrFea + 1
        elif (oneinalldates < rawdateinint_cur) and (not cond2):
            lol_drvr_fea_vec.append(na_fea_list2)
        else:
            print "ERROR: " + inspect.currentframe().f_back.f_lineno + DRIVER_SYMBOLS_WITHCSV[iSym] + " " + oneinalldates + " " + rawdateinint_cur
            sys.exit(1)
    molol_input_features_vec_aligned[DRIVER_SYMBOLS_WITHCSV[iSym]] = lol_drvr_fea_vec

if DEBUGMODE==True:
    print molol_input_features_vec_aligned
    print len(molol_input_features_vec_aligned)


####################################
# aggregated training data
####################################
for iSym in range(0,len(DRIVER_SYMBOLS_WITHCSV)):
    if (len(list_hlrangepctg_subj_aligned) != len(molol_input_features_vec_aligned[DRIVER_SYMBOLS_WITHCSV[iSym]])):
        print "ERROR: ", DRIVER_SYMBOLS_WITHCSV[iSym], len(list_hlrangepctg_subj_aligned), "  ", len(molol_input_features_vec_aligned[DRIVER_SYMBOLS_WITHCSV[iSym]]) #, inspect.currentframe().f_back.f_lineno
        print molol_input_features_vec_aligned[DRIVER_SYMBOLS_WITHCSV[iSym]]
        sys.exit(1)


fout = open(SVMTRAININGDATAFILE,'w')

for iLineNo in range(0,len(list_hlrangepctg_subj_aligned)):

    fout.write(str(list_of_alldates_int[iLineNo]))
    fout.write("@")

    if (list_hlrangepctg_subj_aligned[iLineNo] == "NA"):
        fout.write("NA  ")
    # else:
    #     fout.write(str(list_hlrangepctg_subj_aligned[iLineNo]) + "  ")
    elif (list_hlrangepctg_subj_aligned[iLineNo] > THRESHOLD):
        fout.write("+1  ")
    else:
        fout.write("-1  ")

    featureCnt=1
    for iSym in range(0,len(DRIVER_SYMBOLS_WITHCSV)):
        if iLineNo == 0: print featureCnt, ": ", DRIVER_SYMBOLS_WITHCSV[iSym]
        fout.write(str(featureCnt)+':'+str(molol_input_features_vec_aligned[DRIVER_SYMBOLS_WITHCSV[iSym]][iLineNo][1])+' ')
        featureCnt=featureCnt+1
        if iLineNo == 0: print featureCnt, ": ", DRIVER_SYMBOLS_WITHCSV[iSym]
        fout.write(str(featureCnt)+':'+str(molol_input_features_vec_aligned[DRIVER_SYMBOLS_WITHCSV[iSym]][iLineNo][2])+' ')
        featureCnt=featureCnt+1
        if iLineNo == 0: print featureCnt, ": ", DRIVER_SYMBOLS_WITHCSV[iSym]
        fout.write(str(featureCnt)+':'+str(molol_input_features_vec_aligned[DRIVER_SYMBOLS_WITHCSV[iSym]][iLineNo][3])+' ')
        featureCnt=featureCnt+1

    fout.write('\n')

fout.close()
