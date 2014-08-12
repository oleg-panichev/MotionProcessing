close all; clear all; clc;

addpath('code');

% load('db/Удары/аперкот/data.mat'); fs=1000;
% load('db/Удары/кросс/data.mat'); fs=1000;
% load('db/Удары/свинг/data.mat'); fs=1000;
% load('db/Удары/сила удара/data.mat'); fs=1000;
% load('db/Удары/p_3/data.mat'); fs=20;
% load('db/Удары/p_4/data.mat'); fs=20;
% load('D:\BioWave\motion\matlab\db\Удары\сила удара грав\data.mat'); fs=1000;
% load('D:\BioWave\MotionProcessing\matlab\db\Удары\Cross_punch_power\data.mat'); fs=1000;
% load('D:\BioWave\MotionProcessing\matlab\db\Удары\Swing_punch_power\data.mat'); fs=1000;
load('D:\BioWave\MotionProcessing\matlab\db\Удары\Uppercut_punch_power\data.mat'); fs=1000;

% Check for NaNs
[acc_x,acc_y,acc_z,gyr_x,gyr_y,gyr_z] = ...
  removeNaNs(acc_x,acc_y,acc_z,gyr_x,gyr_y,gyr_z);

% Signal and processing parameters
len=numel(acc_x);
t=0:1/fs:(len-1)/fs;

% Preprocessing
[acc_x,acc_y,acc_z]=filterAcc(acc_x,acc_y,acc_z);

% Motion detection
[m_start,m_stop,m]=detectPunches(acc_x,acc_y,acc_z,fs,round(0.5*fs));
disp(['# of detected motions (starts): ',num2str(numel(m_start))]);
disp(['# of full motions (starts+stops): ',num2str(numel(m_stop))]);

% Punch power
bodyMass=70;
[punchesPowerBuf,punchesIdxBuf,f]=estPunchPower(bodyMass,acc_x,acc_y,acc_z,m_start,m_stop);

% Visualization of detected punches
plotDetectedPunches(acc_x,acc_y,acc_z,t,fs,m_start,m_stop,m,f,punchesIdxBuf);

% Punches classification
segNum=3;
compCoef=0;
[pat_x,pat_y,pat_z]=getPunchPatterns(acc_x,acc_y,acc_z,m_start,m_stop,segNum,compCoef);

% Visualization of punch patterns
plotPunchPatterns(acc_x,acc_y,acc_z,pat_x,pat_y,pat_z,t,fs,m_start,m_stop);
