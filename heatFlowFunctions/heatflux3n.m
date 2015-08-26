function HF = heatflux3n(m,dT,dt)

% Preallocation (Maybe better to pass this variable and define in parent
% function)
Q = zeros(size(dT));


[~,k] = lookupHeatCap( m );

for i=1:6
    Q(:,:,:,i) = - k(:,:,:) ...
        .*dT(:,:,:,i)./m.dist(:,:,:,i).*m.A(:,:,:,ceil(i/2))*dt;
end

% All directions
% for i=1:6
%     Q(:,:,:,i) = - m.material.thermalConductivity(:,:,:) ...
%         .*dT(:,:,:,i)./m.dist(:,:,:,i).*m.A(:,:,:,ceil(i/2))*dt;
% end

% Sum up
HF = sum(Q,4);
end