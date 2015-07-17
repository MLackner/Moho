function M = areas( pos,m )

% The positions don't neccessary match the node positions. So we search the
% nearest nodes to the given positions
% Get the node postions
np = cell(1,3);
for i=1:3
    np{i} = nodePos( m,i );
end
for i=1:size( pos,1 )
    for j=1:6
        % Get current dimension
        dim = ceil(j/2);
        posVal = pos(i,j);
        % Search nearest
        nearest = searchNearest( np{dim},posVal );
        % Overwrite approximate value
        pos(i,j) = nearest;
    end
end


% Calculate number of attached areas
num = size( pos,1 );
% Preallocate
L = zeros( size( m.elements,1 ),8,6,num );
L = logical( L );   % Convert to logical
% Find matrix elements
for i=1:num
    for j=[1,3,5]
        dim = ceil( j/2 );
        L(:,:,j,i) = m.elements(:,:,dim)>=pos(i,j);
    end
    for j=[2,4,6]
        dim = ceil( j/2 );
        L(:,:,j,i) = m.elements(:,:,dim)<=pos(i,j);
    end
    
    Logi = L(:,:,1,i).*L(:,:,2,i).*L(:,:,3,i).*L(:,:,4,i).*L(:,:,5,i).*L(:,:,6,i);
    Logi = sum( Logi,2 );
    Logi = Logi>0;
    
    mlogi(:,i) = Logi;
    
end

% Define an empty matrix
M = m.Vol*0;
% Convert to a logical matrix
M = logical(M);
% Set matrix elements that are adjectant to heat sinks to 'true'
for i=1:num
    M(mlogi(:,i)==1) = 1;
end

end