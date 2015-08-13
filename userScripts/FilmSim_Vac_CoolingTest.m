%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/PtFilmSample_Vac_Cooling.mat' )

%% Set parameters
sp.simTime = 250.1;            % s
sp.dt = 5e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [0:5:sp.simTime];
sp.saveData = true;
sp.folderName = 'PtFilmSampleVac_Cooling';


%% Save data
if exist( ['./data/', sp.folderName], 'dir' )
    
    result = input('Overwrite existing folder? (y/n)   ', 's');
    
    if strcmp(result,'y')
        runSim = true;
    else
        runSim = false;
    end
    
else
    runSim = true;
end



%% Run simulation

if runSim
    M = heatflow( m,sp );
end