%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/testMesh.mat' )

%% Set parameters
sp.simTime = 3600;            % s
sp.dt = 5e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [1:100 200:100:3600];
sp.saveData = true;

%% Run simulation
M = heatflow( m,sp );