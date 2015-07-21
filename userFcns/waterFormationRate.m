function r = waterFormationRate( A,p,T,alpha )
% Calculates the water formation rate on a platinum surface according to
% the kinetic model of Hellsing, Kasemo and Zhdanov. (Journal of Catalysis
% 132, 210-228 (1991)).
%
% Output unit is the number of reacting moles per second.
%
%   A       = surface area in m^2
%   p       = pressure in Pa
%   T       = surface temperature in K
%   alpha   = ratio of partial pressures of oxygen and hydrogen

AVOGADRO = 6.022140857e23;  % Avogadro constant in /mol

Zw = surfaceImpingementRate( p,T );
s = stickingCoefficient( alpha,T );

r = 2*s.*Zw.*A./AVOGADRO;

end

function Zw = surfaceImpingementRate( p,T )
% Calculates the surface impingement rate according to the Hertz-Knudsen
% function.
%
% Output is in molecules per second per square metre
%
%   p = pressure in Pa
%   T = temperature in K

AVOGADRO = 6.022140857e23;  % Avogadro constant in /mol
R = 8.3144621;              % Gas constant in J/mol/K
M = 0.032;                  % Molar mass of oxygen (O2) in kg/mol

Zw = AVOGADRO*p./(sqrt( 2*pi*M*R*T ));

end

function s = stickingCoefficient( alpha,T )
% Calculates the sticking coefficient of oxygen
%   alpha = ratio of partial pressures of oxygen and hydrogen in gas phase

% Sticking coefficint for oxygen at zero coverage
% T. Perger et al. / Combustion and Flame 142 (2005) 107?116
S0 = 0.024*300./T;

s = 2*S0*sqrt( alpha./(1 - alpha) );

end