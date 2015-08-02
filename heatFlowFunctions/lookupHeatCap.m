function heatCapacityDiscrete = lookupHeatCap( m )

% sz = size( m.Vol );
% heatCapacityDiscrete = zeros( size( m.Vol ) );
% parfor i=1:numel( m.Vol )
%     [x,y,z] = ind2sub( sz,i );
%     
%     heatCapacityDiscrete(i) = ...
%         squeeze( m.material.heatCapacity(x,y,z,round( m.temperature(i) )) );
% end

% Preallocate output variable
heatCapacityDiscrete = zeros( size(m.Vol) );
% Get approximate temperatures
T = round( m.temperature );
% heat cap vals
Cp = m.material.heatCapacityValues;

% Loop through all elements
for i=1:numel(m.Vol)
    
    % Current temp
    temp = T(i);
    matIdx = m.material.index(i);
    tempIdx = temp - m.tempRange(1) + 1;
    
    % Get material index
%     try
        heatCapacityDiscrete(i) = ...
            Cp(matIdx,tempIdx);
%     catch
%         fprintf( 'Error! \nCould not access heat capacity value for %s at a temperature of %g K\nbecause precalculated values are available for a temperature\nrange from %g to %g K. Try to increase temperature range.\n', m.material.names{matIdx}, T(i), m.tempRange(1), m.tempRange(end) )
%         fprintf( '\tError occured at m.Vol(%g)\n\n', i )
%         return
%     end
end

end