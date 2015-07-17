%% Set the parameters

% Set the base coordinates of the volume ( x y z );
base = [0 0 0];
% Number of nodes in each dimension
npd = [20 20 20];       % Nodes per dimension (x y z)
% Dimensions (x y z) in meters
dims = [5e-3 5e-3 1e-3];
% Node density calculation parameters
a = [500 500 500];
b = [0.5 0.5 0.5];
c = [50 50 50];

%% Create mesh

[nodes,elements,m] = meshGen( base,npd,dims,a,b,c );

%% View nodes
viewNodes( nodes )