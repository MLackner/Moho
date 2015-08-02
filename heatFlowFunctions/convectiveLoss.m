function Q = convectiveLoss( m )
% This function calculates the convective and conductive heat loss from the
% surface elements to the gas based on surface temperature and gas pressure

totalPressure = m.reaction.partialPressure_Oxy...
    + m.reaction.partialPressure_Hyd ...
    + m.reaction.partialPressure_H2O;

% The surface that loses heat is the same as for radiation
surf = m.radiation.surface;
% Temperature gradient of all elements to the environment (i.e. gas)
dT = m.temperature - m.ambientTemperature;
% Get heat transfer coefficient in W/m^2/K/Pa
h = m.conductiveHeatTransfer;

% Calculate heat flow
Q = -h.*surf.*dT*totalPressure;

end