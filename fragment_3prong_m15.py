import FWCore.ParameterSet.Config as cms

from Configuration.Generator.Pythia8CommonSettings_cfi import *
from Configuration.Generator.MCTunes2017.PythiaCP5Settings_cfi import *
from Configuration.Generator.PSweightsPythia.PythiaPSweightsSettings_cfi import *

generator = cms.EDFilter("Pythia8GeneratorFilter",
                                 comEnergy = cms.double(13000.0),
                                 crossSection = cms.untracked.double(8.45E-6),
                                 filterEfficiency = cms.untracked.double(1.0),
                                 maxEventsToPrint = cms.untracked.int32(0),
                                 pythiaPylistVerbosity = cms.untracked.int32(0),
                                 pythiaHepMCVerbosity = cms.untracked.bool(False),
                                 PythiaParameters = cms.PSet(

    pythia8CommonSettingsBlock,
    pythia8CP5SettingsBlock,
    pythia8PSweightsSettingsBlock,
    processParameters = cms.vstring(
      'Main:timesAllowErrors    = 10000',
      #'HiggsSM:all=true',
      #'25:m0 = 125.0',
      #'25:onMode = off',
      #'25:addChannel = 1  1.00   103   22   553',
      #'Bottomonium:all = on',
      'Bottomonium:gg2bbbar(3S1)[3S1(1)]g    = on,off,off',
      'Bottomonium:gg2bbbar(3S1)[3S1(1)]gm   = on,off,off',
      'Bottomonium:gg2bbbar(3S1)[3S1(8)]g    = on,off,off',
      'Bottomonium:qg2bbbar(3S1)[3S1(8)]q    = on,off,off',
      'Bottomonium:qqbar2bbbar(3S1)[3S1(8)]g = on,off,off',
      'Bottomonium:gg2bbbar(3S1)[1S0(8)]g    = on,off,off',
      'Bottomonium:qg2bbbar(3S1)[1S0(8)]q    = on,off,off',
      'Bottomonium:qqbar2bbbar(3S1)[1S0(8)]g = on,off,off',
      'Bottomonium:gg2bbbar(3S1)[3PJ(8)]g    = on,off,off',
      'Bottomonium:qg2bbbar(3S1)[3PJ(8)]q    = on,off,off',
      'Bottomonium:qqbar2bbbar(3S1)[3PJ(8)]g = on,off,off',
      '553:m0 = 15.0',
      '553:mMin = 14.99995',
      '553:mMax = 15.00005',
      '553:onMode = off',
      '553:onIfMatch = 15 -15',
      '15:onMode = off',
      '15:onIfAll = 211 211 211',
      '15:onIfAll = 211 211 321',
      '15:onIfAll = 211 321 321',
      '15:onIfAll = 321 321 321',
      '15:onIfAll = 211 211 211',
      '15:onIfAll = 211 211 321',
      '15:onIfAll = 211 321 321',
      '15:onIfAll = 321 321 321',
      ),

    parameterSets = cms.vstring(
      'pythia8CommonSettings',
      'pythia8CP5Settings',
      'pythia8PSweightsSettings',
      'processParameters')
    )
)

#upsilonfilter = cms.EDFilter("PythiaFilter",
#    Status = cms.untracked.int32(2),
#    MaxEta = cms.untracked.double(1000.0),
#    MinEta = cms.untracked.double(-1000.0),
#    MinPt = cms.untracked.double(2),
#    ParticleID = cms.untracked.int32(553)
#)

ProductionFilterSequence = cms.Sequence(generator) #*upsilonfilter
