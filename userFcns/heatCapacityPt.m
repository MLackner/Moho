function cp = heatCapacityPt( T )
% Calculates the heat capacity of platinum in J/kg/K from input temperature
% T in K. Formula from:
%
% A.C Macleod, Enthalpy and derived thermodynamic functions of platinum and a platinum + rhodium alloy from 400 to 1700 K, The Journal of Chemical Thermodynamics, Volume 4, Issue 3, 1972, Pages 391-399, ISSN 0021-9614, http://dx.doi.org/10.1016/0021-9614(72)90022-5.
% (http://www.sciencedirect.com/science/article/pii/0021961472900225)

% Molar mass of platinum in kg/mol
M = 0.195;
% Calories to Joule
cal2J = 4.1868;

% Heat Capacity
cp = cal2J/M*(5.58 + 15.12e-4*T + 15876./T.^2);


end