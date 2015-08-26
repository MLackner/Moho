function [heatCapacity,thermalCond] = lookupHeatCap( m )


heatCapacity = zeros( size(m.Vol) );
thermalCond = zeros( size(m.Vol) );

T = m.temperature;


for i=1:numel( m.material.names )
    
    cp = interp1( m.tempRange, m.material.heatCapacityValues(i,:), T );
    heatCapacity(m.material.index==i) = cp(m.material.index==i);
    
    k = interp1( m.tempRange, m.material.thermalCondValues(i,:), T );
    thermalCond(m.material.index==i) = k(m.material.index==i);
        
    
end

end