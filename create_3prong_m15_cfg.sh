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

echo BEGINNING DEBUG in create_3prong_m15_cfg.sh !!
echo '#######'
echo below is the output from printenv in create_3prong_m15_cfg.sh
printenv 
echo '######'
echo below is the output from which cmsRun in create_3prong_m15_cfg.sh
var1='which cmsRun'
eval $var1

echo '#######'
#echo BEGINNING DEBUG in create_3prong_m15_cfg.sh !!
echo '##########'
echo CMSSW_10_2_14 created OK in create_3prong_m15_cfg.sh !
echo '#########'
#curl -s --insecure https://cms-pdmv.cern.ch/mcm/public/restapi/requests/get_fragment/HIG-RunIIFall18GS-00017 --retry 2 --create-dirs -o Configuration/GenProduction/python/HIG-RunIIFall18GS-00017-fragment.py 
mkdir -pv $CMSSW_BASE/src/Configuration/GenProduction/python
cp fragment_3prong_m15.py $CMSSW_BASE/src/Configuration/GenProduction/python
cd $CMSSW_BASE/src
scram b -j8
cd -

echo About to run the cmsDriver in create_3prong_m15_cfg.sh...
echo '######'
cmsDriver.py Configuration/GenProduction/python/fragment_3prong_m15.py --fileout file:GENSIM.root --mc --eventcontent RAWSIM --datatier GEN-SIM --conditions 102X_upgrade2018_realistic_v18 --beamspot Realistic25ns13TeVEarly2018Collision --step GEN,SIM --nThreads 8 --geometry DB:Extended --era Run2_2018 --python_filename run_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 5000

echo cmsDriver has run OK in create_3prong_m15_cfg.sh !!
echo '####'
echo About to run cmsRun in create_3prong_m15_cfg.sh... 
cmsRun -e -j rt.xml run_cfg.py
echo cmsRun was OK in create_3prong_m15_cfg.sh !
echo #####

rm rt.xml
rm run_cfg.py

echo Got through create_3prong_m15_cfg.sh OK!!
