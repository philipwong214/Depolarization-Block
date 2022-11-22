%% Main file for simulating the odor profile (ethyl butyrate) over the arena for different source concentrations

%% Initialize

clearvars
close all 
maindir = mfilename('fullpath');
[maindir,name,ext] = fileparts(maindir);
addpath(genpath(maindir));
cd(maindir);

%% Load Arena Geometry

load('arena.mat')

%% Set Source Concentrations to simulate

conditions = {'EtB100uM'; 'EtB1mM'; 'EtB10mM'; 'EtB25mM'; 'EtB50mM'; 'EtB75mM'; 'EtB100mM'; 'EtB250mM'; 'EtB500mM'; 'EtB10uM'; 'EtB1uM';'EtB50uM'};

%% Simulate Odor Profiles

for i = 1:length(conditions)

%% Set Condition

condition = conditions{i};

%% Specify PDE Parameters

param = [0.0056,8.6926e-05,0,6.7261e-06,2.5e-3,5.09e-2,1.52e-7,2.53e-9,0,30];

%% Generate Mesh and Solve

time = 0:360;
result = odor_sim(model,condition,param,time);

%% Save Data

savedir = fullfile(maindir,'Simulation Results\Odor Diffusion Model');
cd(savedir);

savename = strcat(condition,'.mat');
save(savename,'condition','model','result');

end