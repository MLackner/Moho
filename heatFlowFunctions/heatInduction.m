function P = heatInduction(t,pulseEnergy)
% Define the power of induction in J/s dependend on time. Returns the
% energy induced in given time step



%% Define function
% if t(i)>(Nt*dt/2)
%     P = 0;
% elseif rem(t(i),20)==0
%     P = 1;
% else
%     P = 0;
% end

% P = 1*sin(1000*t(i));
% if P<0
%     P = 0;
% end

% Preallocate arrays
P = zeros(1,length(t));

% Peak time
tm = 12e-12;

for i=1:length(t)
    if t(i) <= tm
        P(i) = t(i)/tm^2;
    elseif t(i) < 2*tm
        P(i) = -t(i)/tm^2+(2/tm);
    else
        P(i) = 0;
    end
end

P = P*pulseEnergy;

end