function dT = tempGradient3( T )

% Preallocate Tatrix
dT = zeros( size( T,1 ),size( T,2 ),size( T,3 ),6);

% X1 Difference
dT(2:end,:,:,1) = T(2:end,:,:) - T(1:end-1,:,:);
% X2 Difference
dT(1:end-1,:,:,2) = T(1:end-1,:,:) - T(2:end,:,:);
% Y1 Difference
dT(:,2:end,:,3) = T(:,2:end,:) - T(:,1:end-1,:);
% Y2 Difference
dT(:,1:end-1,:,4) = T(:,1:end-1,:) - T(:,2:end,:);
% Z1 Difference
dT(:,:,2:end,5) = T(:,:,2:end) - T(:,:,1:end-1);
% Z2 Difference
dT(:,:,1:end-1,6) = T(:,:,1:end-1) - T(:,:,2:end);

% Due to floating point numbers there it is possible that the calculated
% differences are not exactly zero for the same values.
dT(abs(dT)<2e-13) = 0;

end