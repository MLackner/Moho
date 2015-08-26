%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/SampleMesh.mat' )

%% Set parameters
sp.simTime = 60.1;            % s
sp.dt = 10e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [0:5:sp.simTime];
sp.saveData = true;
sp.folderName = 'SampleData';

%% Save data
if exist( ['./data/', sp.folderName], 'dir' )
    
    result = input('Overwrite existing folder? (y/n)   ', 's');
    
    if strcmp(result,'y')
        runSim = true;
    else
        runSim = false;
        return
    end
    
else
    runSim = true;
end



%% Run simulation

if runSim
    M = heatflow( m,sp );
end
