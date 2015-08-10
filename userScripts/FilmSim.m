%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/Films.mat' )

%% Set parameters
sp.simTime = 5e-8;            % s
sp.dt = 1e-14;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [0:1e-10:sp.simTime];
sp.saveData = true;

%% Run simulation
M = heatflow( m,sp );