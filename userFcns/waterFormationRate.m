function [r] = waterFormationRate( m )
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

r = zeros( size( m.Vol ) );

GASCONSTANT = 8.3144621;              % Gas constant in J/mol/K
PREEXPONENTIAL = 1.54e17;%1.1e4;               % Preexponential factor in mol/s/m^2
PARAMETER = 7e3*4.184;                % Parameter A in J/mol
Z = 1;                                % Exponential factor
DESORPACTENERGY = 213.4e3;%16e3*4.184;         % Activation energy for desorption of H2
COVERAGE = 1;                         % Surface coverage in pre-ignition regime
S0_Oxy = 0.11;                        % Sticking coefficient for oxygen
S0_Hyd = 0.30;                        % Sticking coefficient for hydrogen
M_Oxy = 0.032;                        % Molar mass oxygen in kg/mol
M_Hyd = 0.002;                        % Molar mass hydrogen in kg/mol

% Extract data from structure
gasTemperature = m.ambientTemperature;
pressure_Oxy = m.reaction.partialPressure_Oxy;
pressure_Hyd = m.reaction.partialPressure_Hyd;
surfTemperature = m.temperature;


% Calculate the desorption rate of H2
rd = desorptionRate();

% Calculate the surface impingement rate in moles per square meter per
% second.
Zw_Oxy = surfaceImpingementRate( pressure_Oxy,gasTemperature,M_Oxy );
Zw_Hyd = surfaceImpingementRate( pressure_Hyd,gasTemperature,M_Hyd );

% Calculate the temperature dependece of the sticking coefficient
s_Oxy = S0_Oxy;%stickingCoefficientTemp( S0_Oxy,m.ambientTemperature,surfTemperature );
s_Hyd = S0_Hyd;%stickingCoefficientTemp( S0_Hyd,m.ambientTemperature,surfTemperature );


% Calculate the rate of reaction (go through every single surface element
%   Check if the temperature of the element is above the ignition
%   temperature via calculation the difference beteween actual and ignition
%   temperature.
%   In a second step ignore negative values of the water formation rate.

for i=1:numel( m.Vol )
        
    if (2*Zw_Oxy*s_Oxy) > rd(i)
        % Oxygen desorption rate is limiting the reaction rate
        r(i) = rd(i) * (Zw_Oxy*s_Oxy/(Zw_Hyd*s_Hyd))^(-1);
    elseif (2*Zw_Oxy*s_Oxy) <= (Zw_Hyd*s_Hyd)
        % Oxygen sticking is the limiting step
        r(i) = 2*Zw_Oxy.*s_Oxy;
    elseif 2*Zw_Oxy*s_Oxy >= Zw_Hyd*s_Hyd
        % Hydrogen sticking is limiting.
        r(i) = Zw_Hyd.*s_Hyd;
    end
    
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

    function rd = desorptionRate()
        % Calculates the desoprtion rate of H2 in mol/m^2/s
        
        rd = PREEXPONENTIAL * ...
            exp( -(DESORPACTENERGY) ...
            ./(surfTemperature*GASCONSTANT) );
        
    end

end