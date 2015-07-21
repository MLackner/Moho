clc,clear,close all

%% Set the parameters

% Set the base coordinates of the volume ( x y z );
base = [0 0 0];
% Number of nodes in each dimension
npd = [20 20 10];       % Nodes per dimension (x y z)
% Dimensions (x y z) in meters
dims = [5e-3 5e-3 1e-3];
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
m.tempRange = 280:2000;    % only integer values allowed
m.temperature = ones( size( m.Vol ) )*T0;

%% Set materials

m.material.density = zeros( size( m.Vol ) );
m.material.thermalConductivity = zeros( size( m.Vol ) );
m.material.heatCapacityFcn = cell( size( m.Vol ) );
m.material.heatCapacity = zeros( [size( m.Vol ), numel( m.tempRange )] );

% SiO2
SiO2pos = [ 0, dims(1), 0, dims(2), 0, dims(3) ];

m.material.SiO2.area = areas( SiO2pos,m );

m.material.names = {};
m = setMaterial( m, 'SiO2' );

%% Define position of heat sinks

% Cartesian coordinates [x1,1 x1,2 y1,1 y1,2, z1,1 z1,2; x2,1 x2,2, ... ] 
HSpos = [...
    1e-3, 2e-3, 0, 5e-3, 0, 0;
    0.3e-3, 1.3e-3, 4.5e-3, 5e-3, 1e-3, 1e-3;
    4.5e-3, 5e-3, 0.3e-3, 1.3e-3, 1e-3, 1e-3
    ];

m.sink.HS = areas( HSpos,m );

%% Set heat sink parameters

% Heat capacity of the heat sinks
m.sink.heatCapacity = 80;
% Temperature
m.sink.temperature = 300;

%% Define position of heat sources

HeatPos1 = [1e-3, 5e-3, 0, 5e-3, 0, 0];

m.source.Heat = areas( HeatPos1,m );

%% Set heat source parameters

% Set a heating rate (can be a constant or a function handle)
m.source.rate = @heatingRate;

%% Define radiative areas

% Set Coordinates
radi = [...
    0, dims(1), 0, 0, 0, dims(3);
    0, dims(1), dims(2), dims(2), 0, dims(3);
    0, 0, 0, dims(2), 0, dims(3);
    0, dims(1), 0, dims(2), 0, 0;
    0, dims(1), 0, dims(2), dims(3), dims(3);
    ];

% Set emissivity
m.radiation.emissivity = 1;

% Calculate surface areas
m.radiation.Elements = areas( radi,m );
m.radiation.surface = searchSurf( m,m.radiation.Elements );

%% Define the area where the reaction takes place

% Set coordinates
react = [4e-3, dims(1), 0, dims(2), dims(3), dims(3)];

% Calculate areas
m.reaction.Elements = areas( react,m );
% Calculate surface
m.reaction.surface = searchSurf( m,m.radiation.Elements );
% Temperature dependent reaction rate coefficient
m.reaction.rate = @reactionRate;

%% Other initial properties of this system

% Initial thermal energy of the system
m.energy = t2e( m );
m.initEnergy = sum( m.energy(:) );

%% Save this mesh

save( './meshes/testMesh.mat', 'm' )