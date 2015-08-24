%% Test simulation
clc,clear,close all

%% Load mesh
load( './meshes/PtWire_WFR_11.mat' )

%% Set parameters
sp.simTime = 5.1;            % s
sp.dt = 2e-3;                % s
sp.numberSteps = round( sp.simTime/sp.dt );
sp.visualize = true;
sp.saveSteps = [0:20e-3:sp.simTime];
sp.saveData = true;
sp.folderName = 'PtWire_WFR_11_IGN';

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
subplot(3,1,1)
plot(M.output.time,M.output.heatingRate)
ylabel( 'Heating Rate [W]' )

subplot(3,1,2)
plot(M.output.time,M.output.meanTempAtRSurf)

subplot(3,1,3)
plot(M.output.time,M.output.heatSinkTemp)

load handel;
player = audioplayer(y, Fs);
play(player);