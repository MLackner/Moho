%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/testMesh3.mat' )

%% Set parameters
sp.simTime = 400;            % s
sp.dt = 5e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [0:2:50 60:10:190 200:100:3600];
sp.saveData = true;

%% Run simulation
M = heatflow( m,sp );