%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/mesh_MIM_detail.mat' )

%% Set parameters
sp.simTime = 100.1;          % s
sp.dt = 2e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [0:1:sp.simTime];
sp.saveData = true;
sp.folderName = 'MIM_detail';

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
load handel;
player = audioplayer(y, Fs);
play(player);

figure
subplot(3,1,1); hold on
plot( M.output.time, M.output.heatingRate )
ylabel( 'Power at ITO [W]' )
subplot(3,1,2); hold on
plot( M.output.time, M.output.meanTempAtRSurf )
ylabel( 'Film Temperature [K]' )
subplot(3,1,3); hold on
plot( M.output.time, M.output.heatSinkTemp )
ylabel( 'Sink Temperature [K]' )
xlabel( 'Time [s]' )