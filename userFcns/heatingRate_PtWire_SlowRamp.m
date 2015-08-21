function P = heatingRate_PtWire_Vac( m,t )
% Calculates the dissipated power in the sample at a given time.
%
%   Input:
%   m   =   Mesh
%   t   =   Current simulation time in s
%
%   Output:
%   P   =   Total dissipated power in the sample in W
%

% Set maximum voltages for each heating cycle in volt
Umax = [1.2];

% Set start and end times for the heating cycles in seconds
ton = [1];
toff = [250];

% Set the applied base voltage in volt
U0 = 0.015;

% Set voltage ramp in V/s
ramp = 0.005;


% Get the mean temperature of ITO film (Supposed to be the temperature of the
% layer in which the energy is induced) and calculate its resistance

% Get matrix indices of the heat source elements
idx = m.source.Heat;
% Get temperatures of the heat source elements
Temperatures = m.temperature(idx);
% Calculate the mean temperature of all these elements
T = mean( Temperatures(:) );

% Temperature dependence of Pt resistance
R_Pt = (T - 273.15 + 150)/283.196;


% Calculate applied voltage
for i=1:numel( Umax )
    
    if t >= ton(i) && t <= toff(i)
        % Sample is heated
        % Calculated applied voltage drop based on the used ramp
        U = (t - ton(i))*ramp + U0;
        
        if U > Umax(i)
            % Voltage based on ramp is higher than maximum voltage.
            % Set voltage to maximum voltage
            U = Umax(i);
        end
        
        % Applied voltage found. Leave the for loop.
        break
        
    else
        % Sample is not heated.
        % Use base voltage
        U = U0;
    end
    
end

% Calculate dissipated power in W
P = U^2/R_Pt;

end