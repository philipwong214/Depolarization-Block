%% Main file for simulating the Or42b OSN in response to stimulus by ethyl butyrate (Figure 5)

% This script has the following parameters:
% n_trials - sets the number of trials to simulate.
% variability - determines whether inter trial/animal variability is present.
% group - select type of stimulus to simulate,
%       (1) Ramp stimulus patterns used for model fitting (Figure 5C)
%       (2) Odor step stimuli (Figures 5D, 5E, S3B, S3C)
%       (3) Other stimulus patterns displaying hysteresis (Figures 5H, S4C)
%       (4) Odor experience from behavioral replay of real larva trajectories (Figures S4A, S4B)
% condition - select odor stimulus pattern to simulate:
%       (Group 1) 1: exponential ramp, 2: linear ramp, 3: sigmoid ramp,
%       (Group 2) 1: 500 pM, 2: 1 nM, 3: 5 nM, 4: 10 nM, 5: 50 nM, 6: 100 nM,
%                 7: 500 nM, 8: 1 μM, 9: 5 μM, 10: 10 μM, 11: 100 μM, 12: 1 mM
%       (Group 3) 1,2: hysteretic stimulus patterns for Figure S4C, 
%                 3: slow linear odor ramp for Figure 5H
%       (Group 4) 1,2,3: behavioral replays for Figure S4A
%                 4: behavioral replay for Figure S4B


%% Initialize Workspace

%Clear Workspace
clearvars

%Close Windows
close all

%Set Main Directory
code_dir = fileparts(mfilename('fullpath'));
cd(code_dir)
addpath(genpath(code_dir));

%Set Figure Directory
fig_dir = fullfile(code_dir,'Figures');
cd(fig_dir)

%% Import Data

load('FullData.mat');

%% Simulation Parameters

n_trials = 5; %Number of Trials
variability = 1; % 0: Without Noise, 1: With Noise.

%Select condition to simulate
group = 2;
condition = 10;

%% Run Simulation

simulate_osn

%% Plot Figure

plot_osnsystem


