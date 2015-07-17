function p = nodePos( m, dim )
% Get position of nodes in specified dimension

p = unique( m.nodes(:,dim) );

end