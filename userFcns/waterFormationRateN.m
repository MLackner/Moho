function [r,dCov_Hyd,dCov_Oxy,lim] = waterFormationRateN( m )
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
SITEAREA = 1.696e-18;%4e-20;                     % Site area in m^2
GASCONSTANT = 8.3144621;              % Gas constant in J/mol/K
PREEXPONENTIAL = 1e13/6e23/SITEAREA;               % Preexponential factor in mol/s/m^2
DESORPACTENERGY = 19e3*4.184;         % Activation energy for desorption of H2
DESORPPARAMETER = 8e3*4.184;
OHACTENERGY = 9.2e3*4.184;                    %
SURFCOV_HYD = m.reaction.surfCov_Hyd;
SURFCOV_OXY = m.reaction.surfCov_Oxy;
S0_Oxy = 0.11;                        % Sticking coefficient for oxygen
S0_Hyd = 0.30;                        % Sticking coefficient for hydrogen
M_Oxy = 0.032;                        % Molar mass oxygen in kg/mol
M_Hyd = 0.002;                        % Molar mass hydrogen in kg/mol
x_Oxy = 3;
x_Hyd = 0.5;

% Calculate total surface coverage
SURFCOV_TOT = SURFCOV_HYD + SURFCOV_OXY;

% Extract data from structure
gasTemperature = m.ambientTemperature;
pressure_Oxy = m.reaction.partialPressure_Oxy;
pressure_Hyd = m.reaction.partialPressure_Hyd;
surfTemperature = m.temperature;


% Calculate the desorption rate coefficient of H2
kd_Hyd = desorptionRate();

% Calculate the surface impingement rate in moles per square meter per
% second.
Zw_Oxy = surfaceImpingementRate( pressure_Oxy,gasTemperature,M_Oxy );
Zw_Hyd = surfaceImpingementRate( pressure_Hyd,gasTemperature,M_Hyd );


% Calculate the temperature dependece of the sticking coefficient
s_Oxy = S0_Oxy;%stickingCoefficientTemp( S0_Oxy,m.ambientTemperature,surfTemperature );
s_Hyd = S0_Hyd;%stickingCoefficientTemp( S0_Hyd,m.ambientTemperature,surfTemperature );

% Calculate the adsorption rate coefficients of O2 and H2
ka_Hyd = adsorptionRate( Zw_Hyd, S0_Hyd, x_Hyd );
ka_Oxy = adsorptionRate( Zw_Oxy, S0_Oxy, x_Oxy );

% Calculate the reaction rate coefficient of hydrogen to water
rf_Hyd = reactionRate().*SURFCOV_HYD.*SURFCOV_OXY;
% The reaction rate for oxygen is therefore
rf_Oxy = 0.5*rf_Hyd;

% Calculate change in surface coverage
% Hydrogen
dCov_Hyd = ka_Hyd.*(1 - SURFCOV_TOT).^x_Hyd - kd_Hyd.*SURFCOV_HYD.^2 - ...
    rf_Hyd;
% Oxygen
dCov_Oxy = ka_Oxy.*(1 - SURFCOV_TOT).^x_Oxy - ...
    rf_Oxy;


% Calculate the rate of reaction (go through every single surface element
%   Check if the temperature of the element is above the ignition
%   temperature via calculation the difference beteween actual and ignition
%   temperature.
%   In a second step ignore negative values of the water formation rate.

for i=1:numel( m.Vol )
    
    % Calculate the change in hydrogen surface coverage
        
    if (2*Zw_Oxy*s_Oxy) > rf_Oxy(i)
        % Formation of OH intermediate is the limiting step
        lim = 'OH formation';
        r(i) = rf_Hyd(i);
    elseif (2*Zw_Oxy*s_Oxy) <= (Zw_Hyd*s_Hyd)
        % Oxygen sticking is the limiting step
        lim = 'O2 sticking';
        r(i) = 2*Zw_Oxy.*s_Oxy;
    elseif 2*Zw_Oxy*s_Oxy >= Zw_Hyd*s_Hyd
        % Hydrogen sticking is limiting.
        lim = 'H2 sticking';
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

    function ra = adsorptionRate( Zw,S0,x )
        % Calculate adsorption rate
        
        ra = Zw*S0.*(1 - SURFCOV_TOT).^x;
        
    end

    function rd = desorptionRate()
        % Calculates the desoprtion rate of H2 in mol/m^2/s. The desoprtion
        % rate for oxygen is 0 for sufficiently low temperatures
        
        rd = PREEXPONENTIAL * ...
            exp( -(DESORPACTENERGY - DESORPPARAMETER*SURFCOV_TOT) ...
            ./(surfTemperature*GASCONSTANT) );
        
    end

    function rf = reactionRate()
        % Calculate reaction rates
        
        rf = PREEXPONENTIAL * ...
            exp( -(OHACTENERGY) ...
            ./(surfTemperature*GASCONSTANT) );
        
    end

end