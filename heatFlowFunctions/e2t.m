function temperature = e2t( m )

%% Lookup heat capacity
heatCapacity = lookupHeatCap( m );

%% Calculate a thermal energy matrix
temperature = ...
        m.energy ...
        ./heatCapacity ...
        ./m.material.density./m.Vol;

end