function r = waterFormationRate2( Area,pressure,temperature,alpha )
% Calculates the water formation rate on a platinu surface according to the
% kinetic model of Fassihi et al. (Journal of Catalysis 141, 438-452
% (1993))
%
% Output unit is the number of reacting moles per second.
%
%   Area       = surface area in m^2
%   pressure       = pressure in Pa
%   temperature       = surface temperature in K
%   alpha   =   ratio of partial pressures of oxygen and hydrogen for the
%               ureacted gas

AVOGADRO = 6.022140857e23;  % Avogadro constant in /mol
SITEAREA = 4e-20;           % Area a single molecule needs to adsorb on the surface
GASCONSTANT = 8.3144621;              % Gas constant in J/mol/K
MOLARMASS = 0.032;                  % Molar mass of oxygen (O2) in kg/mol
WIRERADIUS = 0.2e-3;
DIFFUSIONCOEFF_HYD = 0.63e-4;   % Diffusion coefficient for Hydrogen in m^2/s. Taken from Fassihi et al.
DIFFUSIONCOEFF_OXY = 0.18e-4;   % See above

Zw = surfaceImpingementRate( pressure,temperature );
s = stickingCoefficient( alpha,temperature );

r = 2*s.*Zw.*Area./AVOGADRO;


    function Zw = surfaceImpingementRate( p,T )
        % Calculates the surface impingement rate according to the Hertz-Knudsen
        % function.
        %
        % Output is in molecules per second per site area
        %
        %   pressure = pressure in Pa
        %   temperature = temperature in K
        
        Zw = AVOGADRO*p./(sqrt( 2*pi*MOLARMASS*GASCONSTANT*T ));
        
    end

    function s = stickingCoefficient( alpha,T )
        % Calculates the sticking coefficient of oxygen
        %   alpha = ratio of partial pressures of oxygen and hydrogen in gas phase
        
        % Sticking coefficint for oxygen at zero coverage
        % T. Perger et al. / Combustion and Flame 142 (2005) 107?116
        S0 = 0.024*300./T;
        
        % Alpha values can't be negative
        alpha(alpha<0) = 0;
        
        s = 2*S0.*sqrt( alpha./(1 - alpha) );
        
    end

    function alphaSurf = alphaNearSurface( alpha,pressure,temperature )
        % The reaction changes the relative conentrations of hydrogen and oxygen
        % near the surface
        
        % Partial pressures
        pressure_Hyd = alpha*pressure;
        pressure_Oxy = pressure - pressure_Hyd;
        % Molecule density (number of molecules per cubic metre)
        molDensity_Oxy = AVOGADRO*pressure_Oxy/GASCONSANT/temperature;
        molDensity_Hyd = AVOGADRO*pressure_Hyd/GASCONSANT/temperature;
        
        molDens
        
    end

end % WaterFormationRate2