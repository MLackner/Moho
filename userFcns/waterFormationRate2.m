function [r] = waterFormationRate2( m )
% Calculates the water formation rate on a platinum surface
%
%   Output:
%   r       = Output unit is the number of reacting moles per second.
%
%   Input:
%   Area        = surface area in m^2
%   pressure    = pressure in Pa
%   temperature = surface temperature in K
%   alpha       = ratio of partial pressures of oxygen and hydrogen for the
%                   ureacted gas

GASCONSTANT = 8.3144621;              % Gas constant in J/mol/K

% Extract data from structure
gasTemperature = m.ambientTemperature;
pressure_Oxy = m.reaction.partialPressure_Oxy;
pressure_Hyd = m.reaction.partialPressure_Hyd;
S0_Oxy = m.reaction.stickingCoefficient_Oxy;
S0_Hyd = m.reaction.stickingCoefficient_Hyd;
ignTemperature = m.reaction.ignitionTemperature;
surfTemperature = m.temperature(m.reaction.Elements)'; % Get only the elements where the reaction takes place

% Calculate the surface impingement rate in moles per square meter per
% second.
Zw_Oxy = surfaceImpingementRate( pressure_Oxy,gasTemperature,0.032 );
Zw_Hyd = surfaceImpingementRate( pressure_Hyd,gasTemperature,0.002 );

% Calculate the temperature dependece of the sticking coefficient
s_Oxy = S0_Oxy;%stickingCoefficientTemp( S0_Oxy,m.ambientTemperature,surfTemperature );
s_Hyd = S0_Hyd;%stickingCoefficientTemp( S0_Hyd,m.ambientTemperature,surfTemperature );

% Calculate the rate of reaction (go through every single surface element
%   Check if the temperature of the element is above the ignition
%   temperature via calculation the difference beteween actual and ignition
%   temperature.
%   In a second step ignore negative values of the water formation rate.

isIgn = (surfTemperature - ignTemperature);
isIgn(isIgn<0) = 0;
isIgn(isIgn>0) = 1;

if Zw_Oxy*s_Oxy <= Zw_Hyd*s_Hyd
    r = 2*Zw_Oxy.*s_Oxy .* isIgn;
elseif Zw_Oxy*s_Oxy >= Zw_Hyd*s_Hyd
    r = Zw_Hyd.*s_Hyd .* isIgn;
end

    function Zw = surfaceImpingementRate( p,T,M )
        % Calculates the surface impingement rate according to the Hertz-Knudsen
        % function.
        %
        % Output is in moles per second per square meter
        %
        %   pressure = pressure in Pa
        %   temperature = temperature in K
        
        Zw = p./(sqrt( 2*pi*M*GASCONSTANT*T ));
        
    end

    function s = stickingCoefficientTemp( S0,Tr,T )
        % Calculates the sticking coefficient of a gas with an initial sticking
        % coefficient S0 (with initial temperature Tr) at a temperature T
        
        s = S0*Tr./T;
        
    end

end % WaterFormationRate2