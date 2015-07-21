%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/testMesh.mat' )

%% Set parameters
sp.simTime = 30;            % s
sp.dt = 2e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = 1;
sp.saveData = true;

%% Run simulation
M = heatflow( m,sp );