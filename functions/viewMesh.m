function viewMesh( m )

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
title( 'Radiation/Convection Surface' )

end