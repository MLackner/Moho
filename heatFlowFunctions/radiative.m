function Qrad = radiative( m )
% Calculate radiative heat flux in J/s

sboltz = 5.670373e-8;

Qrad = m.radiation.emissivity*sboltz.*m.radiation.surface.*(m.temperature - m.ambientTemperature).^4;

end