%%%%%%%%%%%%%%%%
%%% Get temperature profile
%%%%%%%%%%%%%%%%

filePath = 'data/MIM_detail/';

dirInfo = dir( 'data/MIM_detail/*.mat' );
numFiles = numel( dirInfo );


for j=1:numFiles
    
    load( [filePath dirInfo(j).name] )
    
    T_array = m.temperature(m.reaction.Elements);
    
    T = zeros( 22,14 );
    
    for i=1:numel(T)
        T(i) = T_array(i);
    end
    
    Tmean = round( mean( T(:) ) );
    
    
    fileName = ['export/MIM_detail/', 'Profile_', num2str( Tmean ), '.dat'];
    dlmwrite( fileName, T )
    
    
end


figure
surf( T )
title( sprintf( 'Mean Temperature: %g K', mean( T(:) )  ) )