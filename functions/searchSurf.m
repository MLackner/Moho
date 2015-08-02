function A = searchSurf( m,pos )
% Calculate the surface area of each matrix element in a mesh m at 
% positions pos.

A = zeros( size(pos) );
% Go through every element
for i=1:numel(pos)
    if pos(i) == true
        % Surface area radiates heat
        
        % Determine size of the surface area.
        for j=1:6
            % Get current dimension
            dim = ceil(j/2);
            % Get subindex of element that radiates
            [a,b,c] = ind2sub( size( pos ),i );
            
            % If the distance to the next element in direction j is
            % infinite the this is a surface
            if m.dist(a,b,c,j) == inf
                % Surface
                
                % Get Area
                A(i) = A(i) + m.A(a,b,c,dim);
            end
            
        end
    end
end

end