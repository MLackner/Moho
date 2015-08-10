%% Properties of SiO2 (BK7)

SiO2.density = 2203;                % kg/m^3
SiO2.heatCapacityFcn = @heatCapacitySiO2;            % J/kg/K
SiO2.thermalConductivity = 1.114;   % W/m/K

save('./materials/SiO2','SiO2')

%% Properties of Platinum
Pt.density = 21450;                % kg/m^3
Pt.heatCapacityFcn = @heatCapacityPt;              % J/kg/K
Pt.thermalConductivity = 71.6;      % W/m/K

save('./materials/Pt','Pt')