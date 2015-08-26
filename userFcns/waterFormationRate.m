function [r,dCov_Hyd,dCov_Oxy,lim] = waterFormationRateN( m )
% Calculates the water formation rate on a platinum surface
%
%   Output:
%   r           =   Output unit is the number of reacting moles per second 
%                   per square meter.
%
%   Input:
%   m           =   Mesh
%

% Preallocate matrix for reaction rates
r = zeros( size( m.Vol ) );

% Define reaction parameters
% Site area in m^2
SITEAREA = 4e-20;       
% Gas constant in J/mol/K
GASCONSTANT = 8.3144621;   
% Pre-exponential for the hydrogen desorption
PREEXPONENTIAL_HD = 1e13/6.022e23/SITEAREA;
% Pre-exponential for the formation of the OH intermediate
PREEXPONENTIAL_OH = 1e13/6.022e23/SITEAREA;
% Activation energy for the desorption of H2 in J/mol
DESORPACTENERGY = 16e3*4.1868;     
% Parameter for calculationg the coverage dependece of the desorption
% energy of H2 in J/mol
DESORPPARAMETER = 8e3*4.1868;
% Activation energy for the formation of the OH intermediate
OHACTENERGY = 54.3e3;
% Set the sticking coefficient O2
S0_Oxy = 0.11; 
% Sticking coefficient for H2
S0_Hyd = 0.30;
% Molar mass of O2 in kg/mol
M_Oxy = 0.032;
% Molar mass of H2 in kg/mol
M_Hyd = 0.002;
% Exponents for calculating the coverage dependence of the sticking
% coefficients
x_Oxy = 3;
x_Hyd = 0.5;


% Extract data from structure
gasTemperature = m.ambientTemperature;
pressure_Oxy = m.reaction.partialPressure_Oxy;
pressure_Hyd = m.reaction.partialPressure_Hyd;
surfTemperature = m.temperature;

% Surface coverage calculation
% Get the surface converages of H2 and O2
SURFCOV_HYD = m.reaction.surfCov_Hyd;
SURFCOV_OXY = m.reaction.surfCov_Oxy;
% Calculate total surface coverage
SURFCOV_TOT = SURFCOV_HYD + SURFCOV_OXY;

% Calculate the desorption rate coefficient of H2
kd_Hyd = desorptionRate();

% Calculate the surface impingement rate in moles per square meter per
% second.
Zw_Oxy = surfaceImpingementRate( pressure_Oxy,gasTemperature,M_Oxy );
Zw_Hyd = surfaceImpingementRate( pressure_Hyd,gasTemperature,M_Hyd );

% Calculate the adsorption rate coefficients of O2 and H2
ka_Hyd = adsorptionRate( Zw_Hyd, S0_Hyd, x_Hyd );
ka_Oxy = adsorptionRate( Zw_Oxy, S0_Oxy, x_Oxy );

% Calculate the reaction rate coefficient of hydrogen to water
rf_Hyd = reactionRate().*SURFCOV_HYD.*SURFCOV_OXY;
% The reaction rate for oxygen is therefore
rf_Oxy = 0.5*rf_Hyd;

% Calculate change in surface coverages
% Hydrogen
dCov_Hyd = ka_Hyd.*(1 - SURFCOV_TOT).^x_Hyd - kd_Hyd.*SURFCOV_HYD.^2 - ...
    rf_Hyd;
% Oxygen
dCov_Oxy = ka_Oxy.*(1 - SURFCOV_TOT).^x_Oxy - ...
    rf_Oxy;

% Calculation of the reaction rates for every single volume element. Check
% first if the "ignition condition" is met. This is approximated by the
% surface coverages of hydrogen and oxygen (better expression is needed)
for i=1:numel( m.Vol )
        
    if (SURFCOV_OXY(i) > 0.1) && (SURFCOV_HYD(i) > 0.1)
        % Formation of OH intermediate is the limiting step
        lim = 'OH formation';
        r(i) = rf_Hyd(i);
    elseif (2*Zw_Oxy*S0_Oxy) <= (Zw_Hyd*S0_Hyd)
        % Oxygen sticking is the limiting step
        lim = 'O2 sticking';
        r(i) = 2*Zw_Oxy.*S0_Oxy;
    elseif 2*Zw_Oxy*S0_Oxy >= Zw_Hyd*S0_Hyd
        % Hydrogen sticking is limiting.
        lim = 'H2 sticking';
        r(i) = Zw_Hyd.*S0_Hyd;
    end
    
end

    function Zw = surfaceImpingementRate( p,T,M )
        % Calculates the surface impingement rate according to the 
        % Hertz-Knudsen equation
        %
        % Output is in moles per second per square meter
        %
        %   p = pressure in Pa
        %   T = temperature in K
        %   M = molar mass in kg/mol
        
        Zw = p./(sqrt( 2*pi*M*GASCONSTANT*T ));
        
    end

    function ka = adsorptionRate( Zw,S0,x )
        % Calculates adsorption rate coefficient
        %
        %   Zw = surface impingement rate
        %   S0 = sticking coefficient
        %   x  = exponent describing surface coverage dependence
        
        ka = Zw*S0.*(1 - SURFCOV_TOT).^x;
        
    end

    function kd = desorptionRate()
        % Calculates the desoprtion rate coefficient of H2 in mol/m^2/s. 
        % The desoprtion rate coefficient for oxygen is 0 for sufficiently 
        % low temperatures
        
        kd = PREEXPONENTIAL_HD * ...
            exp( -(DESORPACTENERGY - DESORPPARAMETER*SURFCOV_TOT) ...
            ./(surfTemperature*GASCONSTANT) );
        
    end

    function kf = reactionRate()
        % Calculates reaction rate coefficient
        
        kf = PREEXPONENTIAL_OH * ...
            exp( -(OHACTENERGY) ...
            ./(surfTemperature*GASCONSTANT) );
        
    end

end