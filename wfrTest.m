

m.ambientTemperature = 300;
m.reaction.partialPressure_Oxy = 400;
m.reaction.partialPressure_Hyd = 100;
m.temperature = 300:100:1000;
m.reaction.Elements = true( size( m.temperature ) );
m.Vol = zeros( size( m.temperature ) );

r = waterFormationRate( m )

plot( m.temperature, r )