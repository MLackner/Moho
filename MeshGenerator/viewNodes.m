function viewNodes( nodes )

x = nodes(:,1);
y = nodes(:,2);
z = nodes(:,3);

fh = figure;
sp = scatter3( x,y,z,'.' );
xlabel( 'X' )
ylabel( 'Y' )
zlabel( 'Z' )
axis equal

end