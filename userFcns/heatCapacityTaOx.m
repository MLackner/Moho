function cp = heatCapacityTaOx( T )
% Value taken from DOI: 10.1021/ja01108a005

p = [ 4.8286e-15   8.4834e-08  -0.00030623      0.41538       216.29];

cp = polyval( p,T );

end