function k = thermalConductivitySiO2( T )

load fitModel_thermalCondSiO2

k = zeros( size( T ) );

for i=1:numel( k )
    k(i) = thermalCondSiO2( T(i) );
end

end