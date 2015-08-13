function resistance = calculateResistance( m )
% Calculates the resistance of specified elements m.measurement.MSpos along
% a direction m.measurement.MSdir at a given temperature
% 


% Get elements
elements = m.measurement.MSpos;
% Get direction
dir = m.measurement.MSdir;
% Get length of each element
elementLength = m.ElementWidth{dir} .* elements;
% Get Temperature of the elements
temperature = m.temperature .* elements;
% Calculate resistance of each element.
resistanceSingle = m.measurement.resistanceFcn( temperature )...
    .*elementLength .* elements ./ m.A(:,:,:,dir);

% Sum up resistances
resistance = sum( resistanceSingle(:) );

end