function resistivity = PtTemperatureResistance( T )
% Function returns the resistivity in Ohm*m (independent on area)
% This is for a platinum wire of 0.1 mm thickness.

resistivity = 0.1*T/300;

end