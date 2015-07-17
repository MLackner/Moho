function k = reactionRate( T,Ea,k0 )

% Gas constant
R = 8.3144621;  % J/mol/K

% Arrhenius
k = k0.*exp( -Ea./R./T );

end