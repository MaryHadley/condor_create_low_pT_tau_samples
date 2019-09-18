#!/bin/bash
export SCRAM_ARCH=slc6_amd64_gcc700
source /cvmfs/cms.cern.ch/cmsset_default.sh
if [ -r CMSSW_10_2_14/src ] ; then 
    echo release CMSSW_10_2_14 already exists
else
    scram p CMSSW CMSSW_10_2_14
fi
cd CMSSW_10_2_14/src
eval `scram runtime -sh`
cd ../..
echo BEGIN DEBUG in create_3prong_m15_miniaod_cfg.sh 
echo '####'
echo Checking printenv in create_3prong_m15_miniaod_cfg.sh 
printenv
echo '#####'
echo Checking which cmsRun in create_3prong_m15_miniaod_cfg.sh
var2='which cmsRun'
eval $var2


echo '####'
echo about to run cmsDriver.py step1 --filein file:GENSIM.root step in create_3prong_m15_miniaod_cfg.sh...
echo '#####'
cmsDriver.py step1 --filein file:GENSIM.root --fileout file:UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1.root --pileup_input "das:/MinBias_TuneCP5_13TeV-pythia8/RunIIFall18GS-102X_upgrade2018_realistic_v9-v1/GEN-SIM" --mc --eventcontent RAWSIM --pileup "AVE_25_BX_25ns,{'N': 20}" --datatier GEN-SIM-RAW --conditions 102X_upgrade2018_realistic_v18 --beamspot Realistic25ns13TeVEarly2018Collision --step DIGI,L1,DIGI2RAW,HLT:@relval2018 --nThreads 8 --geometry DB:Extended --era Run2_2018 --python_filename UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 10000 || exit $? ; 
echo cmsDriver step1 blah from above ran OK in create_3prong_m15_miniaod_cfg.sh !!
echo '####'
echo about to try cmsRun in create_3prong_m15_miniaod_cfg.sh... 
cmsRun -e -j UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_cfg.py || exit $? ; 
echo I got through cmsRun OK in create_3prong_m15_miniaod_cfg.sh !!
echo 10000 events were run
grep "TotalEvents" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml
if [ $? -eq 0 ]; then
    grep "Timing-tstoragefile-write-totalMegabytes" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml 
    if [ $? -eq 0 ]; then
        events=$(grep "TotalEvents" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml | tail -1 | sed "s/.*>\(.*\)<.*/\1/")
        size=$(grep "Timing-tstoragefile-write-totalMegabytes" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml | sed "s/.* Value=\"\(.*\)\".*/\1/")
        if [ $events -gt 0 ]; then
            echo "McM Size/event: $(bc -l <<< "scale=4; $size*1024 / $events")"
        fi
    fi
fi

grep "EventThroughput" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml 
if [ $? -eq 0 ]; then
  var1=$(grep "EventThroughput" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml | sed "s/.* Value=\"\(.*\)\".*/\1/")
  echo "McM time_event value: $(bc -l <<< "scale=4; 1/$var1")"
fi
echo CPU efficiency info:
grep "TotalJobCPU" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml 
grep "TotalJobTime" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1_rt.xml

rm GENSIM.root

cmsDriver.py step2 --filein file:UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1.root --fileout file:UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_aod.root --mc --eventcontent AODSIM --runUnscheduled --datatier AODSIM --conditions 102X_upgrade2018_realistic_v18 --beamspot Realistic25ns13TeVEarly2018Collision --step RAW2DIGI,L1Reco,RECO,EI --nThreads 8 --geometry DB:Extended --era Run2_2018 --python_filename UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 10000 || exit $? ;

cmsRun -e -j UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_cfg.py || exit $? ;

echo 10000 events were ran 
grep "TotalEvents" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml 
if [ $? -eq 0 ]; then
    grep "Timing-tstoragefile-write-totalMegabytes" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml 
    if [ $? -eq 0 ]; then
        events=$(grep "TotalEvents" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml | tail -1 | sed "s/.*>\(.*\)<.*/\1/")
        size=$(grep "Timing-tstoragefile-write-totalMegabytes" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml | sed "s/.* Value=\"\(.*\)\".*/\1/")
        if [ $events -gt 0 ]; then
            echo "McM Size/event: $(bc -l <<< "scale=4; $size*1024 / $events")"
        fi
    fi
fi
grep "EventThroughput" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml 
if [ $? -eq 0 ]; then
  var1=$(grep "EventThroughput" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml | sed "s/.* Value=\"\(.*\)\".*/\1/")
  echo "McM time_event value: $(bc -l <<< "scale=4; 1/$var1")"
fi
echo CPU efficiency info:
grep "TotalJobCPU" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml 
grep "TotalJobTime" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step2_rt.xml 


cmsDriver.py step3 --filein file:UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_aod.root --fileout file:UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_miniaod.root --mc --eventcontent MINIAODSIM --runUnscheduled --datatier MINIAODSIM --conditions 102X_upgrade2018_realistic_v18 --beamspot Realistic25ns13TeVEarly2018Collision --step PAT --nThreads 8 --geometry DB:Extended --era Run2_2018 --python_filename UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 10000 || exit $? ;

cmsRun -e -j UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_cfg.py || exit $? ;

echo 10000 events were ran 
grep "TotalEvents" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml 
if [ $? -eq 0 ]; then
    grep "Timing-tstoragefile-write-totalMegabytes" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml 
    if [ $? -eq 0 ]; then
        events=$(grep "TotalEvents" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml | tail -1 | sed "s/.*>\(.*\)<.*/\1/")
        size=$(grep "Timing-tstoragefile-write-totalMegabytes" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml | sed "s/.* Value=\"\(.*\)\".*/\1/")
        if [ $events -gt 0 ]; then
            echo "McM Size/event: $(bc -l <<< "scale=4; $size*1024 / $events")"
        fi
    fi
fi
grep "EventThroughput" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml 
if [ $? -eq 0 ]; then
  var1=$(grep "EventThroughput" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml | sed "s/.* Value=\"\(.*\)\".*/\1/")
  echo "McM time_event value: $(bc -l <<< "scale=4; 1/$var1")"
fi
echo CPU efficiency info:
grep "TotalJobCPU" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml 
grep "TotalJobTime" UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step3_rt.xml 

rm *_rt.xml
rm UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_*cfg.py
rm UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_step1.root
rm UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_aod.root

