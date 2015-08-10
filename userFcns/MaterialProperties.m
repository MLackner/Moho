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

%% Properties of Tantalum
Ta.density = 16690;                 % Taken from Wikipedia
Ta.heatCapacityFcn = @heatCapacityTa;
Ta.thermalConductivity = 57.5;      % Taken from Wikipedia

save('./materials/Ta','Ta')

%% Properties of Ta(V)-oxide
TaOx.density = 8200;
TaOx.heatCapacityFcn = @heatCapacityTaOx; %DOI: 10.1021/ja01108a005
TaOx.thermalConductivity = 30;      %Guess

save('./materials/TaOx','TaOx')