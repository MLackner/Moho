function P = heatingRate_Ramp600mW( m,t )


ramp = 0.01;

P = ramp*t;

if P>0.9;
    P=0.9;
end


end