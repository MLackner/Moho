function energy = t2e( m )

%% Lookup heat capacity
heatCapacity = lookupHeatCap( m );

%% Calculate a thermal energy matrix
energy = ...
        heatCapacity.*m.temperature.*m.material.density.*m.Vol;

end