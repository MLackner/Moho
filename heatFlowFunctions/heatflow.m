function M = heatflow(m,sp)


fprintf('Calculating...\n')
tic


%% Define index for saved files

% Initial index
fileIndex = 1;
% Generate folder name
folderName = datestr( datetime, 'yyyy-MM-dd_HH-mm' );
mkdir( ['./data/',folderName] );

%% View
if sp.visualize
    m.temperature(1,1,1) = 400;
    fh = figure('WindowStyle','docked');
    xslice = [1, size( m.Vol,2 )];
    yslice = [1, size( m.Vol,1 )];
    zslice = [1, size( m.Vol,3 )];
    p = slice( m.temperature,xslice,yslice,zslice );
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    caxis( [m.tempRange(1) m.tempRange(end)] )
    m.temperature(1,1,1) = 300;
end

%% Calculate a thermal energy matrix
m.energy = t2e( m );

%% Predefine some values
Eind = 0;
Qrad = 0;

%% Calculation
for i=1:sp.numberSteps
    
    %% Get time
    t = sp.dt*(i-1);
    
    if rem(t,sp.saveSteps)==0
        
        %% Get simulation data
        
        % Get run time
        runTime = toc;
        % Get thermal energy
        sumEnergy = sum( m.energy(:) );
        
        %% Print output information
        fprintf( 'Step #%g\n',i )
        fprintf( '\tSimulation time: %g s\n',t )
        fprintf( '\tRun time: %g s\n',runTime )
        fprintf( '\tEnergy in system: %g J\n',sumEnergy )
        fprintf( '\tChange in energy: %g J\n', sumEnergy - sum( m.initEnergy(:) ) )
        fprintf( '\tInduced energy: %g J/s\n', Eind/sp.dt )
        fprintf( '\tRadiated heat: %g J/s\n', sum(Qrad(:))/sp.dt )
        fprintf( '\tMean tempearature: %g K\n', mean( m.temperature(:) ) )
        fprintf( '\tMaximum temperature: %g K\n', max( m.temperature(:) ) )
        fprintf( '\tMinimum temperature: %g K\n', min( m.temperature(:) ) )
        fprintf( '\tMean temperature on reaction surface: %g K\n', mean( m.temperature(m.reaction.Elements) ) )
        fprintf( '\tHeat sink temperature: %g K\n\n', m.sink.temperature )
        
        %% Gather output information
        m.output.time(fileIndex) = t;
        m.output.runTime(fileIndex) = runTime;
        m.output.meanTempAtRSurf(fileIndex) = ...
            mean( m.temperature(m.reaction.Elements) );
        m.output.heatSinkTemp(fileIndex) = m.sink.temperature;
        m.output.meanTemp(fileIndex) = mean( m.temperature(:) );
        m.output.heatRadiated(fileIndex) = sum(Qrad(:))/sp.dt;
        
        %% View Data
        if sp.visualize
            m.temperature(1,1,1) = m.temperature(1,1,1) + 1e-10;
            p = slice( m.temperature,xslice,yslice,zslice );
            m.temperature(1,1,1) = m.temperature(1,1,1) - 1e-10;
            for j=1:numel(p)
                p(j).FaceColor = 'interp';
                p(j).LineStyle = '-';
            end
            caxis( [m.tempRange(1) m.tempRange(end)] )
            colorbar
            pause(1e-15)
        end
        
        %% Save data
        if sp.saveData
            % Set filename
            fileName = ['./data/',folderName,'/dat',int2str(fileIndex)];
            save(fileName,'m','-v6')
        end
        
        % Increase index
        fileIndex = fileIndex + 1;

    end
    
    
    %% Heat induction
    % Get heating rate
    hR = m.source.rate(t);
    
    % Get total energy that is induced
    Eind = hR*sp.dt;
    
    % Calculate induced fraction for each volume element
    produkt = hR*m.source.Heat;
    summe = sum( produkt(:) );
    if hR == 0
        m.source.inducedFrac = 0;
    else
        m.source.inducedFrac = hR.*m.source.Heat./summe;
    end
    
    % Induce
    m.energy = m.energy + m.source.inducedFrac.*Eind;
    
    %% Convert to temperature
    m.temperature = e2t( m );
    
    %% Heat sinks (Before or after flow ????)
    
    % Set temperature where the heat sinks are located to 0
    m.temperature = (1 - m.sink.HS).*m.temperature;
    % Set temperature where the heat sinks are located to sink temperature
    m.temperature(m.temperature==0) = m.sink.temperature;
    % Energy in the system before the heat sinks were applied
    energyPreHeatSink = sum( m.energy(:) );
    
    % Calculate a thermal energy matrix
    m.energy = t2e( m );
    % Energy in the system after the heat sinks were applied
    energyPostHeatSink = sum( m.energy(:) );
    % Energy that went into the heat sinks
    energy2sink = energyPreHeatSink - energyPostHeatSink;
    % Temperature rise in heat sink
    m.sink.temperature = m.sink.temperature ...
        + energy2sink/m.sink.heatCapacity;
    
    %% Radiation
    Qrad = radiative( m )*sp.dt;
    
    % Apply to energy matrix
    m.energy = m.energy - Qrad;
    
    %% Calculate temperature
    m.temperature = e2t( m );
    
    %% Heat flow
    
    % Calculate temperature gradient matrix
    dT = tempGradient3(m.temperature);
    
    % Calculate heat flux matrix
    HF = heatflux3n(m,dT,sp.dt);
    
    % Add heatflux to current matrix to gain new state
    m.energy = m.energy + HF;
    
    %     % Save data
    %     if rem(i,saveSteps)==0 || i == 1
    %         % Set filename
    %         fileName = [savePath,int2str(j)];
    %         save(fileName,'M','-v6')
    %         % Increase index
    %         j = j+1;
    %     end
    
end

% Convert to temperature
m.temperature = e2t( m );

M = m;

toc
end