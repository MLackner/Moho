function [heatCapacity,thermalCond] = lookupHeatCap( m )

% Preallocate output variable
heatCapacity = zeros( size(m.Vol) );
thermalCond = zeros( size(m.Vol) );
% Get approximate temperatures
% Tlower = floor( m.temperature );
T = m.temperature;
% heat cap vals
% Cp = m.material.heatCapacityValues;
% therm cond vals
% k = m.material.thermalCondValues;

% 
% matIdx = m.material.index;
% tempIdx = (Tlower - m.tempRange(1)) + 1;

% Loop through all elements
% for i=1:numel(m.Vol)
%     
% %     Current temp
% %     tempLower = Tlower(i);
% %     matIdx = m.material.index(i);
% %     tempIdx = (tempLower - m.tempRange(1)) + 1;
% %     
%     heatCapacityDiscreteLower = ...
%         Cp(matIdx(i),tempIdx(i));
%     heatCapacityDiscreteUpper = ...
%         Cp(matIdx(i),tempIdx(i)+1);
%     
%     thermalCondDiscreteLower = ...
%         k(matIdx(i),tempIdx(i));
%     thermalCondDiscreteUpper = ...
%         k(matIdx(i),tempIdx(i)+1);
%     
% %     Calcualate difference
%     heatCapacity(i) = ...
%         (heatCapacityDiscreteUpper - heatCapacityDiscreteLower)* ...
%         (T(i) - Tlower(i)) + heatCapacityDiscreteLower;
%     thermalCond(i) = ...
%         (thermalCondDiscreteUpper - thermalCondDiscreteLower)*...
%         (T(i) - Tlower(i)) + thermalCondDiscreteLower;
% 
% end

for i=1:numel( m.material.names )
    
    heatCapacity(m.material.index==i) = interp1( m.tempRange, m.material.heatCapacityValues, T );
    thermalCond(m.material.index==i) = interp1( m.tempRange, m.material.thermalCondValues, T );
    
end

end