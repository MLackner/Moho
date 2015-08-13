function P = heatingRateFS_Vac( t )

Umax1 = 3.0;
Umax2 = 4.5;
Umax3 = 6.0;
Umax4 = 9.0;

U0 = 0.1;

R_ITO = 19;


if t >= 44 && t <= 190
    U = (t - 44)*0.1 + U0;
    if U > Umax1
        U = Umax1;
    end
elseif t >= 234 && t <= 398
    U = (t - 234)*0.1 + U0;
    if U > Umax2
        U = Umax2;
    end
elseif t >= 498 && t <= 707
    U = (t - 498)*0.1 + U0;
    if U > Umax3
        U = Umax3;
    end
elseif t >= 870 && t <= 1231
    U = (t - 870)*0.1 + U0;
    if U > Umax4
        U = Umax4;
    end
else
    U = U0;
end

P = U^2/R_ITO;

end