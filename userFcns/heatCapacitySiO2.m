function Cp = heatCapacitySiO2( T )
% Calculates the heat capacity of KAlSi3O8 glass (range
%
% Krupka, K. M.; Robie, R. A.; Hemingway, B. S. (1979): 
% High-temperature heat capacities of corundum, periclase, anorthite, 
% CaAl/sub 2/Si/sub 2/O/sub 8/ glass, muscovite, pyrophyllite, KAlSi/sub 
% 3/O/sub 8/ glass, grossular, and NaAlSi/sub 3/O/sub 8/ glass. 
% In Am. Mineral.; (United States) 64:1-2.

Cp = 629.5 - 0.1084*T + 2.496e6./T.^2 - 7210./sqrt(T) + 1.928e-5*T.^2; % in J/mol/K
Cp = Cp/0.2502413;  % in J/kg/K

end