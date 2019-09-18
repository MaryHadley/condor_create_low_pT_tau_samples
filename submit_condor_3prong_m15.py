import os,glob
import sys, commands, os, fnmatch
from optparse import OptionParser

def exec_me(command, dryRun=False):
    print command
    if not dryRun:
        os.system(command)

def write_condor(exe='runjob.sh', arguments = [], files = [],dryRun=True):
    job_name = exe.replace('.sh','.jdl')
    out = 'universe = vanilla\n'
    out += 'Executable = %s\n'%exe
    out += 'Should_Transfer_Files = YES\n'
    out += 'WhenToTransferOutput = ON_EXIT_OR_EVICT\n'
    out += 'Transfer_Input_Files = %s,%s\n'%(exe,','.join(files))
    out += 'Output = job_%s.stdout\n'%job_name
    out += 'Error  = job_%s.stderr\n'%job_name
    out += 'Log    = job_%s.log\n'   %job_name
    out += '+JobFlavour = "testmatch"\n' #for cern only
    out += 'request_memory = 8000\n'
    out += 'use_x509userproxy = true\n'
    out += 'x509userproxy = $ENV(X509_USER_PROXY)\n' #needed to run on lxplus, not needed for LPC
    #out += 'notify_user = jduarte1@FNAL.GOV\n'
    #out += 'x509userproxy = /tmp/x509up_u42518\n'
    out += 'Arguments = %s\n'%(' '.join(arguments))
    out += 'Queue 1\n'
    with open(job_name, 'w') as f:
        f.write(out)
    if not dryRun:
        os.system("condor_submit %s"%job_name)

def write_bash(temp = 'runjob.sh', command = ''):
    out = '#!/bin/bash\n'
    out += 'date\n'
    out += 'MAINDIR=`pwd`\n'
    out += 'ls\n'
    out += '#CMSSW from scratch (only need for root)\n'
    out += 'export CWD=${PWD}\n'
    out += 'export PATH=${PATH}:/cvmfs/cms.cern.ch/common\n'
    out += 'export CMS_PATH=/cvmfs/cms.cern.ch\n'
    #out += 'export SCRAM_ARCH=slc6_amd64_gcc700\n' #for LPC
    out += 'export SCRAM_ARCH=slc7_amd64_gcc700\n' #testing if this makes it work on lxplus
    out += 'scramv1 project CMSSW CMSSW_10_2_14\n'
    out += 'cd CMSSW_10_2_14/src\n'
    out += 'eval `scramv1 runtime -sh` # cmsenv\n'
    out += 'cd ../..\n'
    #out += 'scramv1 build -j 4\n'
    out += command + '\n'
    out += 'echo "Inside $MAINDIR:"\n'
    out += 'ls\n'
    out += 'echo "DELETING..."\n'
    out += 'cd $MAINDIR\n'
    out += 'rm -rf CMSSW_10_2_14\n'
    out += 'ls\n'
    out += 'date\n'
    with open(temp, 'w') as f:
        f.write(out)

def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    for i in xrange(0, len(l), n):
        yield l[i:i + n]

if __name__ == '__main__':
    basePath = "."
    sampleFolders = os.listdir(basePath)    
    outputBase = "output_3prong_m15_updated"
    dryRun  = False
    subdir  = os.path.expandvars("$PWD")
    group   = 20
    files = ["das_maps_dbs_prod.js","fragment_3prong_m15.py","create_3prong_m15_cfg.sh","create_3prong_m15_miniaod_cfg.sh"]
   
    for i in range(group):
        outpath  = "%s/sub_%d/"%(outputBase,i)
        if not os.path.exists(outpath):
            exec_me("mkdir -p %s"%(outpath), False)
        os.chdir(os.path.join(subdir,outpath))
        print  os.getcwd()
        for f in files:
            exec_me("cp %s/%s ."%(subdir,f), False)
        exec_me("sed -i -e 's/UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_aod.root/UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_aod_part%d.root/g' create_3prong_m15_miniaod_cfg.sh"%(i), False)
        exec_me("sed -i -e 's/UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_miniaod.root/UpsilonToTauTau_PUPoissonAve20_102X_upgrade2018_realistic_v18_3prong_m15_miniaod_part%d.root/g' create_3prong_m15_miniaod_cfg.sh"%(i), False)

        cmd = "export HOME=${MAINDIR}; mkdir -p ${HOME}/.dasmaps; cp das_maps_dbs_prod.js ${HOME}/.dasmaps/das_maps_dbs_prod.js; . create_3prong_m15_cfg.sh; . create_3prong_m15_miniaod_cfg.sh; mv *.root $MAINDIR"

        args =  []
        f_sh = "runjob_%s.sh"%i
        cwd    = os.getcwd()
        write_bash(f_sh, cmd)
        write_condor(f_sh ,args, files, dryRun)
        os.chdir(subdir)

