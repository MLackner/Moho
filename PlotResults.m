%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% PLOT RESULTS FOR FILM HEATING IN VACUUM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m.output.totalPressure(1) = nan;
%% Plot power at ITO
figure
subplot(2,2,1);
plot( m.output.time, m.output.heatingRate )
ylabel( 'Power at ITO [W]' )
subplot(2,2,2);
plot( m.output.time, m.output.meanTempAtRSurf )
ylabel( 'Film Temperature [K]' )
xlabel( 'Time [s]' )
% subplot(5,1,3); hold on
% plot( m.output.time, m.output.heatSinkTemp )
% ylabel( 'Sink Temperature [K]' )
subplot(2,2,3);
plot( m.output.time, m.output.rate )
ylabel( 'Rate [mol/s]' )
subplot(2,2,4); hold on
plot( m.output.time, m.output.totalPressure )
% plot( m.output.time, m.output.partialPressure_Hyd )
ylabel( 'Pressure [Pa]' )
xlabel( 'Time [s]' )