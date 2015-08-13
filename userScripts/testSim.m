%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/PtWire.mat' )

%% Set parameters
sp.simTime = 400.1;            % s
sp.dt = 1e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [0:0.2:100 102:200 210:10:400];
sp.saveData = true;

%% Run simulation
M = heatflow( m,sp );