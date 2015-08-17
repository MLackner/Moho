function [heatCapacity,thermalCond] = lookupHeatCap( m )

% Preallocate output variable
heatCapacity = zeros( size(m.Vol) );
thermalCond = zeros( size(m.Vol) );
% Get approximate temperatures
Tlower = floor( m.temperature );
T = m.temperature;
% heat cap vals
Cp = m.material.heatCapacityValues;
% therm cond vals
k = m.material.thermalCondValues;

% Loop through all elements
for i=1:numel(m.Vol)
    
    % Current temp
    tempLower = Tlower(i);
    matIdx = m.material.index(i);
    tempIdx = (tempLower - m.tempRange(1)) + 1;
    
    heatCapacityDiscreteLower = ...
        Cp(matIdx,tempIdx);
    heatCapacityDiscreteUpper = ...
        Cp(matIdx,tempIdx+1);
    
    thermalCondDiscreteLower = ...
        k(matIdx,tempIdx);
    thermalCondDiscreteUpper = ...
        k(matIdx,tempIdx+1);
    
    % Calcualate difference
    heatCapacity(i) = (heatCapacityDiscreteUpper - heatCapacityDiscreteLower)*(T(i) - Tlower(i)) + heatCapacityDiscreteLower;
    thermalCond(i) = (thermalCondDiscreteUpper - thermalCondDiscreteLower)*(T(i) - Tlower(i)) + thermalCondDiscreteLower;
    
end

end