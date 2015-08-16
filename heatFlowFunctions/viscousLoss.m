function Q = viscousLoss( m,Hv,Te )
% Calculates the viscous loss to mixtures of oxygen and hydrogen

% Gas constant in J/mol/K
GASCONSTANT = 8.314;
% Molar mass oxygen in kg/mol
M_OXY = 0.032;
% Molar mass hydrogen kg/mol
M_HYD = 0.002;
% cp/cv oxygen
CPCV_OXY = 1.40;
% cp/cv hydrogen
CPCV_HYD = 1.41;
% Degrees of freedom oxygen
DOF_OXY = 5;
% Degrees of freedom hydrogen
DOF_HYD = 5;
% Boltzmann constant
BOLTZMANN = 1.3806488e-23;
% Collision diameters
COLLISIONDIA_OXY = 3.1;
COLLISIONDIA_HYD = 2.74;

% Get parameters from mesh
% Ambient temperature
Tr = m.ambientTemperature;
% Pressures
p_Oxy = m.reaction.partialPressure_Oxy;
p_Hyd = m.reaction.partialPressure_Hyd;
% Geometry coefficient
GEOCOEFF = Hv;

% Calculate mean velocities
c_Oxy = meanVelocity( M_OXY );
c_Hyd = meanVelocity( M_HYD );

% Calculate number densities
n_Oxy = p_Oxy/BOLTZMANN/Tr;
n_Hyd = p_Hyd/BOLTZMANN/Tr;

% Collision diameter of oxygen/hydrogen
COLLISIONDIA_OXYHYD = 0.5*(COLLISIONDIA_OXY + COLLISIONDIA_HYD);

% Calculate mean free paths
l_Oxy = meanFreePath( n_Oxy,n_Hyd,COLLISIONDIA_OXY,COLLISIONDIA_OXYHYD,...
    M_OXY,M_HYD );
l_Hyd = meanFreePath( n_Hyd,n_Oxy,COLLISIONDIA_HYD,COLLISIONDIA_OXYHYD,...
    M_HYD,M_OXY );

% Calculate Heat loss due to oxygen and hydrogen
Q_Oxy = GEOCOEFF*(9*CPCV_OXY - 5)*p_Oxy*DOF_OXY*l_Oxy/c_Oxy/M_OXY;
Q_Hyd = GEOCOEFF*(9*CPCV_HYD - 5)*p_Hyd*DOF_HYD*l_Hyd/c_Hyd/M_HYD;
Q = (Te - Tr)*(Q_Oxy + Q_Hyd);



    function c = meanVelocity( M )
        % Calculate the mean velocity of the gas molecules
        c = sqrt( 8*GASCONSTANT*Tr/pi/M );
    end

    function lambda = meanFreePath( nA,nB,cdA,cdAB,MA,MB )
        % Calculate the mean free path of a gas in a mixture
        lambda = 1/(sqrt(2)*pi*nA*cdA + nB*pi*cdAB*sqrt(1 + MA/MB));
    end

end