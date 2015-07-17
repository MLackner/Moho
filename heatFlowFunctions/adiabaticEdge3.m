function M = adiabaticEdge3(M,adiabatic)
% Set the temperatures at the edges of the matrix equal to one
% element further in.

% Y Dimension
if adiabatic(3)
    M(:,1,:) = M(:,2,:);
end
if adiabatic(4)
    M(:,end,:) = M(:,end-1,:);
end
% X Dimension
if adiabatic(1)
    M(1,:,:) = M(2,:,:);
end
if adiabatic(2)
    M(end,:,:) = M(end-1,:,:);
end
% Z Dimension
if adiabatic(5)
    M(:,:,1) = M(:,:,2);
end
if adiabatic(6)
    M(:,:,end) = M(:,:,end-1);
end

end