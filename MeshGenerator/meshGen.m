function m = meshGen( base,npd,dims,a,b,c )
% Creates a cuboid mesh
% 
% MESHGEN(base, npd, dims, a, b, c)
%
% base      =   [1x3] array. Position of the first node in cartesian 
%               coordinates [x,y,z].
% npd       =   [1x3] array. Number of nodes per dimension (x y z).
% dims      =   [1x3] array. Total length of the system in x y and z
%               direction in meters.
% a,b,c     =   Parameters to define node density in the system. Density is
%               calculated according to y = a*(x - b)^2 + b in the range of
%               0 <= x <= 1.
%


%% Create nodes
tic
disp( 'Creating nodes ...' )

% Get the number of nodes (matrix elements)
numNodes = prod( npd );
% Set node density
pos = nodeDensity( npd,a,b,c );
% Get subindices
[X,Y,Z] = ind2sub( npd,1:numNodes );
% Move nodes to 0,0,0 and arrange dimensions in column vectors
nodes = ([X',Y',Z'] - 1);
% Adjust spacing in x y and z direction
for i=1:3
    % Find specific indices starting with 0
    for j=0:npd(i)-1
        idx = find( nodes(:,i) == j );
        nodes(idx,i) = pos{i}(j+1);
    end
end

for i=1:3
    % Normalize node positions (all range from 0 to 1) expand to wanted
    % size and move to base
    nodes(:,i) = nodes(:,i)*dims(i) + base(i);
end

fprintf( '\t%g nodes created. (%g s)\n', numNodes, toc )

%% Create elements
tic
disp( 'Creating elements ...' )

% Number of elements can be calculated from nuber of nodes per dimension
numElements = prod( npd - 1 );

% Get indices of nodes that are the "root" of an element. E.g. no nodes at
% the ends of the system
r = (1:numNodes)';     % All nodes
l = zeros(numNodes,3);
for j=1:3
    % Search for indices to delete
    l(:,j) = nodes(:,j)==dims(j);
end
l = sum( l,2 );
l = l~=0;
r(l) = [];    % Delete nodes

% Create elements
elements = zeros( numel( r ),8,3 );
for j=1:numel( r )
    % Get indices of nodes for individual elements
    idx = [r(j), r(j)+1, ...
        r(j)+npd(1), r(j)+npd(1)+1, ...
        r(j)+npd(1)*npd(2), r(j)+npd(1)*npd(2)+1, ...
        r(j)+npd(1)*(npd(2)+1), r(j)+npd(1)*(npd(2)+1)+1]';
    
    for i=1:8
        elements(j,i,:) = nodes(idx(i),:);
    end
end

% % Search adjectant nodes of every node
% j = 1;  % Counter for element number
% for i=1:numNodes
%     % Get node coordinates
%     x = nodes(i,1);
%     y = nodes(i,2);
%     z = nodes(i,3);
%     % This is the first node of the element
%     element(j,1,1:3) = [x y z];
%     
%     % Search for possible adjectant nodes in x direction (column 1) that
%     % are greater than the current x value
%     xDir = nodes(:,1) > x;
%     % Search in y and z direction for nodes with same coordinates
%     yDir = nodes(:,2) == y;
%     zDir = nodes(:,3) == z;
%     % All possible locations are
%     xPosLoc = logical( xDir.*yDir.*zDir );
%     % These might be multiple but we search for the lowest value of those
%     xx = min( nodes(xPosLoc,1) );
%     % If we reached the last node in a dimension we get an empty value and
%     % have to continue with the next loop iteration
%     if isempty( xx )
%         element(j,:,:) = [];
%         continue
%     end
%     % Now we've got the second node
%     element(j,2,1:3) = [xx y z];
%     
%     % Search for possible adjectant nodes in y direction (column 2) that
%     % are greater than the current y value
%     xDir = nodes(:,1) == x;
%     % Search in y and z direction for nodes with same coordinates
%     yDir = nodes(:,2) > y;
%     zDir = nodes(:,3) == z;
%     % All possible locations are
%     yPosLoc = logical( xDir.*yDir.*zDir );
%     % These might be multiple but we search for the lowest value of those
%     yy = min( nodes(yPosLoc,2) );
%     % If we reached the last node in a dimension we get an empty value and
%     % have to continue with the next loop iteration
%     if isempty( yy )
%         element(j,:,:) = [];
%         continue
%     end
%     % Now we've got the third node
%     element(j,3,1:3) = [x yy z];
%     
%     % Search for possible adjectant nodes in z direction (column 1) that
%     % are greater than the current z value
%     xDir = nodes(:,1) == x;
%     % Search in y and z direction for nodes with same coordinates
%     yDir = nodes(:,2) == y;
%     zDir = nodes(:,3) > z;
%     % All possible locations are
%     zPosLoc = logical( xDir.*yDir.*zDir );
%     % These might be multiple but we search for the lowest value of those
%     zz = min( nodes(zPosLoc,3) );
%     % If we reached the last node in a dimension we get an empty value and
%     % have to continue with the next loop iteration
%     if isempty( zz )
%         element(j,:,:) = [];
%         continue
%     end
%     % Now we've got the second node
%     element(j,4,1:3) = [x y zz];
%     
%     % All other element nodes can be calculated
%     element(j,5,1:3) = [xx y zz];
%     element(j,6,1:3) = [x yy zz];
%     element(j,7,1:3) = [xx yy z];
%     element(j,8,1:3) = [xx yy zz];
%     
%     % Set counter for next element
%     j = j + 1;
%     
% end

fprintf( '\t%g elements created. (%g s)\n', numElements,toc )

%% Convert mesh to matrix
%
% Each mesh element corresponds to a matrix element. Adjectant matrix
% elements correspond to adjectant mesh elements
%

% Create an empty matrix
m = struct;

% Preallocate
d = zeros( 1,3 );
m.Vol = zeros( npd(1)-1,npd(2)-1,npd(3)-1 );
m.A = zeros( size( m.Vol,1 ), size( m.Vol,2 ), size( m.Vol,3 ), 3 );
m.dist = zeros( size( m.Vol,1 ), size( m.Vol,2 ), size( m.Vol,3 ), 6 );
m.centerPoints = zeros( size( m.Vol,1 ), size( m.Vol,2 ), size( m.Vol,3 ), 3 );

tic
disp( 'Calculating matrices ...' )
k = [2 3 5];
for i=1:size( elements,1 )
    %% Get indices of the current matrix element
    [ix,iy,iz] = ind2sub( size( m.Vol ), i );
    idx = [ix iy iz];
    
    %% Calculate the volume of the matrix elements
    
    for j=1:3
        
        d(j) = elements(i,k(j),j) - elements(i,1,j);
        
    end
    
    m.Vol(i) = prod( d );
    
    %% Calculate matrix of areas of the matrix elements (x y z)
    m.A(ix,iy,iz,1) = d(2)*d(3);
    m.A(ix,iy,iz,2) = d(1)*d(3);
    m.A(ix,iy,iz,3) = d(1)*d(2);
    
    %% Calculate coordinates of center points
    for j=1:3
        m.centerPoints(ix,iy,iz,j) = ...
            mean( [elements(i,k(j),j), elements(i,1,j)] );
    end
    
%     %% Calculate distance of center points to adjectant matrices
%     for j=1:6
%         
%         % Get the current dimension
%         currDim = ceil(j/2);
%         % Check if the elements are at the end of the system
%         if rem(j,2)~=0  % To left side
%             
%             if idx(currDim)-1 == 0
%                 m.dist(idx(1),idx(2),idx(3),j) = inf;
%                 continue
%             end
%             
%             idxL = idx;
%             idxL(currDim) = idx(currDim) - 1;
%             m.dist(idx(1),idx(2),idx(3),j) = ...
%                 abs( m.centerPoints(idx(1),idx(2),idx(3),currDim) - ...
%                 m.centerPoints(idxL(1),idxL(2),idxL(3),currDim) );
%         else            % To right side
%             
%             if idx(currDim)+1 > size( m.Vol, (currDim) )
%                 m.dist(idx(1),idx(2),idx(3),j) = inf;
%                 continue
%             end
%             
%             idxR = idx;
%             idxR(currDim) = idx(currDim) + 1;
%             m.dist(idx(1),idx(2),idx(3),j) = ...
%                 abs( m.centerPoints(idx(1),idx(2),idx(3),currDim) -...
%                 m.centerPoints(idxR(1),idxR(2),idxR(3),currDim) );
%         end
        
%     end
    
end

%% Calculate distance of center points to adjectant matrices

m.dist = ones( size( m.Vol,1 ), size( m.Vol,2 ), size( m.Vol,3 ),6 )*inf;
% X1 direction
m.dist(2:end,:,:,1) = abs( m.centerPoints(1:end-1,:,:,1) - m.centerPoints(2:end,:,:,1) );
% X2 direction
m.dist(1:end-1,:,:,2) = abs( m.centerPoints(1:end-1,:,:,1) - m.centerPoints(2:end,:,:,1) );
% Y1 direction
m.dist(:,2:end,:,3) = abs( m.centerPoints(:,1:end-1,:,2) - m.centerPoints(:,2:end,:,2) );
% Y2 direction
m.dist(:,1:end-1,:,4) = abs( m.centerPoints(:,1:end-1,:,2) - m.centerPoints(:,2:end,:,2) );
% Z1 direction
m.dist(:,:,2:end,5) = abs( m.centerPoints(:,:,1:end-1,3) - m.centerPoints(:,:,2:end,3) );
% Z2 direction
m.dist(:,:,1:end-1,6) = abs( m.centerPoints(:,:,1:end-1,3) - m.centerPoints(:,:,2:end,3) );

m.nodes = nodes;
m.elements = elements;

%% Calculate width of each element

for i=1:3
    
    position = pos{i} * dims(i);
    m.ElementWidth{i} = position(2:end) - position(1:end-1);
    
end


fprintf( '\tDone. (%g s)\n', toc )

end
