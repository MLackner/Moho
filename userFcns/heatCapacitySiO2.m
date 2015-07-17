function Cp = heatCapacitySiO2( T )

Cp = 629.5 - 0.1084*T + 2.496e6./T.^2 - 7210./sqrt(T) + 1.928e-5*T.^2; % in J/mol/K
Cp = Cp/0.2502413;  % in J/kg/K

end