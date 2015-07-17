function estimateRunTime( m,sp )

fprintf('Estimating run time...\n')
sp.numberSteps = 100;
tic
heatflow( m,sp );
preT = toc; estT = preT*Nt/preNt;
% Output
fprintf('\tEstimated run time: %g min\n\tapprox. finished:',estT/60)
disp(datetime + seconds(estT))
fprintf('------------------------------\n')

end