function m = setMaterial( m,material )

fprintf( 'Setting material properties of %s ...\n', material )

% Load material data
try
    mat = load( material );
catch
    fprintf('! No material ''%s'' defined.\n',material)
end

% Set material index
matIdx = numel( m.material.names )+1;
% Set name
m.material.names{ matIdx } = material;

locs = m.material.(material).area;  % Get location matrix of material

% Material index
for i=1:numel( m.Vol )
    if m.material.index(i) == 0
        m.material.index(i) = m.material.index(i) + matIdx*locs(i);
    end
end
% Density
m.material.density = ...
    mat.(material).density*locs + m.material.density;
% Thermal Conductivity
m.material.thermalConductivity = ...
    mat.(material).thermalConductivity*locs + m.material.thermalConductivity;

% Precalculate material properties for the defined temperature range in
% m.tempRange.

% Heat Capacity at discrete temperatures
m.material.heatCapacityValues(matIdx,:) = mat.(material).heatCapacityFcn( m.tempRange );
% Thermal Conductivities at discrete temperatures
m.material.thermalCondValues(matIdx,:) = mat.(material).thermalCondFcn( m.tempRange );

fprintf( '\tDone.\n' )

end

