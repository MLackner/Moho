function Kxyz = K3(K)

% Y1 Difference
Kxyz(:,:,:,3) = (K(2:end-1,2:end-1,2:end-1) + K(2:end-1,1:end-2,2:end-1))/2;
% X1 Difference
Kxyz(:,:,:,1) = (K(2:end-1,2:end-1,2:end-1) + K(1:end-2,2:end-1,2:end-1))/2;
% Y2 Difference
Kxyz(:,:,:,4) = (K(2:end-1,2:end-1,2:end-1) + K(2:end-1,3:end,2:end-1))/2;
% X2 Difference
Kxyz(:,:,:,2) = (K(2:end-1,2:end-1,2:end-1) + K(3:end,2:end-1,2:end-1))/2;
% Z1 Difference
Kxyz(:,:,:,5) = (K(2:end-1,2:end-1,2:end-1) + K(2:end-1,2:end-1,1:end-2))/2;
% Z2 Difference
Kxyz(:,:,:,6) = (K(2:end-1,2:end-1,2:end-1) + K(2:end-1,2:end-1,3:end))/2;



end