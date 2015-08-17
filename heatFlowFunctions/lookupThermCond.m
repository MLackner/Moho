function k = lookupThermCond( m )

% Preallocate output variable
thermCond = zeros( size(m.Vol) );
% Get approximate temperatures
Tlower = floor( m.temperature );
T = m.temperature;
% heat cap vals
Cp = m.material.heatCapacityValues;

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
    
end

end
