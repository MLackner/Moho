function pos = nodeDensity( nodesPerDim, a, b, c )


% figure( 'WindowStyle','docked' ); hold on

% Preallocate
spacing = cell(1,numel(nodesPerDim));
x = cell( 1,numel(nodesPerDim) );

for j=1: numel( nodesPerDim )
    x{j} = linspace( 0,1,nodesPerDim(j) );
    spacing{j} = a(j)*(x{j} - b(j)).^2 + c(j);
    
    % Calculate the reciprocal of the spacing vector
    spacing{j} = 1./spacing{j};
    
%     plot( x{j},spacing{j},'o-' )
end

% Preallocate
pos = cell( 1, numel( nodesPerDim ) );

% figure( 'WindowStyle','docked' ); hold on

for j=1:numel( nodesPerDim )
    
    % Preallocate
    pos{j} = zeros( 1,nodesPerDim(j) );
    
    for i=1:nodesPerDim(j) - 1
        pos{j}(i+1) = pos{j}(i) + spacing{j}(i);
    end
    
    % Normalize
    pos{j} = pos{j}/pos{j}(end);
    
%     plot( pos{j},zeros( 1,numel( pos{j} ) ),'o-' )
    
end

end