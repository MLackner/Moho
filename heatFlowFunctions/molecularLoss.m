function Q = molecularLoss( m,Hm,Te )
% Calculates the viscous loss to mixtures of oxygen and hydrogen

% Gas constant in J/mol/K
GASCONSTANT = 8.314;
% Molar mass oxygen in kg/mol
M_OXY = 0.032;
% Molar mass hydrogen kg/mol
M_HYD = 0.002;
% Degrees of freedom oxygen
DOF_OXY = 5;
% Degrees of freedom hydrogen
DOF_HYD = 5;
% Energy accomodation coefficient
EAC = 1;

% Get parameters from mesh
% Ambient temperature
Tr = m.ambientTemperature;
% Pressures
p_Oxy = m.reaction.partialPressure_Oxy;
p_Hyd = m.reaction.partialPressure_Hyd;
% Geometry coefficient
GEOCOEFF = Hm;

% Calculate mean velocities
c_Oxy = meanVelocity( M_OXY );
c_Hyd = meanVelocity( M_HYD );

% Calculate Heat loss due to oxygen and hydrogen
Q_Oxy = GEOCOEFF*EAC*(DOF_OXY + 1)/4*c_Oxy*(Te - Tr)./(Tr + Te)*p_Oxy;
Q_Hyd = GEOCOEFF*EAC*(DOF_HYD + 1)/4*c_Hyd*(Te - Tr)./(Tr + Te)*p_Hyd;

Q = Q_Oxy + Q_Hyd;


    function c = meanVelocity( M )
        % Calculate the mean velocity of the gas molecules
        c = sqrt( 8*GASCONSTANT*Tr/pi/M );
    end

end