function heatCap = heatCapacitySiO2( Temp )
% Calculates the heat capacity of KAlSi3O8 glass (range
%
% Krupka, K. M.; Robie, R. A.; Hemingway, B. S. (1979): 
% High-temperature heat capacities of corundum, periclase, anorthite, 
% CaAl/sub 2/Si/sub 2/O/sub 8/ glass, muscovite, pyrophyllite, KAlSi/sub 
% 3/O/sub 8/ glass, grossular, and NaAlSi/sub 3/O/sub 8/ glass. 
% In Am. Mineral.; (United States) 64:1-2.
%
% For low temperatures:
%
% Robie, R. A.; Hemingway, B. S.; Wilson, W. H. (1978): 
% Low-temperature heat capacities and entropies of feldspar glasses and of
% anorthite. In American Mineralogist 63, pp. 109–123.

heatCap = zeros( size( Temp ) );


for i=1:numel(Temp)
    T = Temp(i);
    
    if T >= 300
        Cp = 629.5 - 0.1084*T + 2.496e6./T.^2 - 7210./sqrt(T) + 1.928e-5*T.^2; % in J/mol/K
    else
        Cp = -3.811e-10*T.^5 + 3.291e-7*T.^4 - 104e-6*T.^3 + 1332e-5*T.^2 + 0.2748*T - 2.172;
    end
    
    Cp = Cp/0.2502413;  % in J/kg/K
    heatCap(i) = Cp;
    
end

end