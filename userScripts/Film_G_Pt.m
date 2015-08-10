clc,clear,close all

%% Set the parameters

% Set the base coordinates of the volume ( x y z );
base = [0 0 0];
% Number of nodes in each dimension
npd = [200 2 2];       % Nodes per dimension (x y z)
% Dimensions (x y z) in meters
dims = [170e-9 2e-9 2e-9];
% Node density calculation parameters y = a*(x - b)^2 + c
a = [0 0 0];
b = [0.5 0.5 0.5];
c = [50 50 50];

%% Create mesh

m = meshGen( base,npd,dims,a,b,c );

%% View nodes
% viewNodes( m.nodes )

%% Set start temperature

T0 = 300;   % Kelvin

% Set temperature range over which material properties are precalculated
m.tempRange = 270:1800;    % only integer values allowed
m.temperature = ones( size( m.Vol ) )*T0;

%% Set materials

m.material.density = zeros( size( m.Vol ) );
m.material.thermalConductivity = zeros( size( m.Vol ) );
m.material.heatCapacityFcn = cell( size( m.Vol ) );
m.material.heatCapacity = zeros( [size( m.Vol ), numel( m.tempRange )] );
m.material.index = zeros( size( m.Vol ) );

% SiO2
SiO2pos = [ 0, 100e-9, 0, dims(2), 0, dims(3) ];
% Ta
Tapos = [100e-9, 148e-9, 0, dims(2), 0, dims(3) ];
% TaOx
TaOxpos = [148e-9, 150e-9, 0, dims(2), 0, dims(3) ];
% Pt
Ptpos = [ 150e-9, 170e-9, 0, dims(2), 0, dims(3) ];

m.material.SiO2.area = areas( SiO2pos,m );
m.material.Ta.area = areas( Tapos,m );
m.material.TaOx.area = areas( TaOxpos,m );
m.material.Pt.area = areas( Ptpos,m );

m.material.names = {};
m = setMaterial( m, 'SiO2' );
m = setMaterial( m, 'Ta' );
m = setMaterial( m, 'TaOx' );
m = setMaterial( m, 'Pt' );

%% Define position of heat sinks

% Cartesian coordinates [x1,1 x1,2 y1,1 y1,2, z1,1 z1,2; x2,1 x2,2, ... ] 
HSpos = [];

m.sink.HS = areas( HSpos,m );

%% Set heat sink parameters

% Heat capacity of the heat sinks in J/K
m.sink.heatCapacity = 1;
% Temperature of the sink in K
m.sink.temperature = 300;
% Ambient temperature in K
m.ambientTemperature = 300;
% Heat loss coefficient in J/s/K/Pa (Total heat loss due to conduction,
% convection and radiation from the sink to the environment, i.e. the
% sample holder to the chamber and the outside itself.
m.sink.lossCoefficient = 0;

% Calculate thermal energy in heat sink
m.sink.energy = m.sink.heatCapacity*m.sink.temperature;

%% Define position of heat sources

HeatPos1 = [0, 0, 0, dims(2), 0, dims(3)];

m.source.Heat = areas( HeatPos1,m );

%% Set heat source parameters

% Set a heating rate (can be a constant or a function handle)
m.source.rate = @heatingRateFilm;

%% Define radiative areas

% Set Coordinates
radi = [...
    dims(1), dims(1), 0, dims(2), 0, dims(3)
    ];

% Set emissivity
m.radiation.emissivity = 1;

% Calculate surface areas
m.radiation.Elements = areas( radi,m );
m.radiation.surface = searchSurf( m,m.radiation.Elements );

%% Define conductive/convective heat transfer coefficient to gas
m.conductiveHeatTransfer = 0;

%% Define the area where the reaction takes place

% Set coordinates
react = [];

% Calculate areas
m.reaction.Elements = areas( react,m );
% Calculate surface
m.reaction.surface = searchSurf( m,m.reaction.Elements );
% Temperature dependent reaction rate coefficient
m.reaction.rate = @reactionRate2;

% Initial partial pressures in Pa
m.reaction.initialPressure_Oxy = 0;
m.reaction.initialPressure_Hyd = 0;

% Ignition temperature
m.reaction.ignitionTemperature = 450;

% Heat of reaction in J/mol
m.reaction.reactionHeat = -242e3;

% Sticking coefficients
m.reaction.stickingCoefficient_Oxy = 0.11;
m.reaction.stickingCoefficient_Hyd = 0.30;

% Make entry for partial pressure at any point in time
m.reaction.partialPressure_Oxy = m.reaction.initialPressure_Oxy;
m.reaction.partialPressure_Hyd = m.reaction.initialPressure_Hyd;
m.reaction.partialPressure_H2O = 0;

%% Other initial properties of this system

% Initial thermal energy of the system
m.energy = t2e( m );
m.initEnergy = sum( m.energy(:) );

% Set the Volume of the chamber in m^3
m.chamberVolume = 0.125;

%% Save this mesh

save( './meshes/Films.mat', 'm' )

%% Clear
clear