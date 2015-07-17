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
m.material.index = matIdx*locs;
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

fprintf( '\tDone.\n' )

end

