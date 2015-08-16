%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PLOT RESULTS FOR FILM HEATING IN VACUUM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load FilmData.mat

%% Plot power at ITO
figure
subplot(3,1,1); hold on
p1 = plot( dat.time-3500, dat.p_ito);
plot( M.output.time, M.output.heatingRate )
ylabel( 'Power at ITO [W]' )
xlim( [0 1700] )
subplot(3,1,2); hold on
plot( dat.time-3500, dat.t_film )
plot( M.output.time, M.output.meanTempAtRSurf )
xlim( [0 1700] )
ylabel( 'Film Temperature [K]' )
subplot(3,1,3); hold on
plot( dat.time-3500, dat.t_pt1000 )
plot( M.output.time, M.output.heatSinkTemp )
xlim( [0 1700] )
ylabel( 'Sink Temperature [K]' )
xlabel( 'Time [s]' )