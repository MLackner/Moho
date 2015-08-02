function viewResultsQuick( m )

surfaceArea = sum( m.reaction.surface(:) );

t = m.output.time;
rate = m.output.rate/surfaceArea;
surfTemp = m.output.meanTempAtRSurf;
meanTemp = m.output.meanTemp;
sinkTemp = m.output.heatSinkTemp;

figure
subplot(2,2,1)
plot( t,rate )
title( 'Reaction Rate' )

subplot(2,2,2)
plot( t,surfTemp )
title( 'Temperature at Surface' )

subplot(2,2,3)
plot( t,meanTemp )
title( 'Mean Temperature in Sample' )

subplot(2,2,4)
plot( t,sinkTemp )
title( 'Heat Sink Temperature' )

end