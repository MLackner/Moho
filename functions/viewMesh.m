function viewMesh( m )

% Get system dimensions
% for i=1:3
%     % Get system dimensions
%     lengthDim(i) = sum( m.ElementWidth{i} );
%     % Get number of elements in each dimension
%     numberElements(i) = size( m.Vol, i );
%     fact(i) = lenthDim(i)/numberElements(i);
% end


fh = figure();

subplot(2,2,1)
HS = m.sink.HS * 1;
xslice = [1, size( m.Vol,2 )];
yslice = [1, size( m.Vol,1 )];
zslice = [1, size( m.Vol,3 )];
slice( HS,xslice,yslice,zslice );
xlabel('X')
ylabel('Y')
zlabel('Z')
title( 'Heat Sinks' )

subplot(2,2,2)
V = m.source.Heat * 1;
xslice = [1, size( m.Vol,2 )];
yslice = [1, size( m.Vol,1 )];
zslice = [1, size( m.Vol,3 )];
slice( V,xslice,yslice,zslice );
xlabel('X')
ylabel('Y')
zlabel('Z')
title( 'Heat Source' )

subplot(2,2,3)
V = m.reaction.Elements * 1;
xslice = [1, size( m.Vol,2 )];
yslice = [1, size( m.Vol,1 )];
zslice = [1, size( m.Vol,3 )];
slice( V,xslice,yslice,zslice );
xlabel('X')
ylabel('Y')
zlabel('Z')
title( 'Reactive Surface' )

subplot(2,2,4)
V = m.radiation.Elements * 1;
xslice = [1, size( m.Vol,2 )];
yslice = [1, size( m.Vol,1 )];
zslice = [1, size( m.Vol,3 )];
slice( V,xslice,yslice,zslice );
xlabel('X')
ylabel('Y')
zlabel('Z')
title( 'Exposed Surface' )

% Set colormap
for i=1:4
    subplot(2,2,i)
    colormap('lines')
    caxis( [ 0 3 ] )
    view( [40 40] )
    set(gca,'LineWidth', 0.2, ...
        'GridAlpha', 0.4,...
        'Clipping','off')
end

end