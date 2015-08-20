%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/PtFilmSample_O2_500.mat' )

%% Set parameters
sp.simTime = 1700.1;            % s
sp.dt = 10e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [0:5:sp.simTime];
sp.saveData = true;
sp.folderName = 'PtFilmSample_O2_500';

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


%% Output
figure

load handel;
player = audioplayer(y, Fs);
play(player);

PlotH2HeatingResults