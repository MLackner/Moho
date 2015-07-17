function A = beamAbs(l,N,beamDia,AC)
% Returns the absorption matrix of a beam in xy plane

%% Preallocate Intensity matrix I
I = zeros(N(1)+2,N(2)+2,N(3)+2);

%% Define beam shape in xy plane
%
% Create a gaussian profile
%

% Define xy plane
XY = zeros(N(1)+2,N(2)+2);
XYsize = size(XY);
[R,C] = ndgrid(1:XYsize(1), 1:XYsize(2));
% Call gauss function with parameters
% Define sigma (variance) for gauss function.
% Length of each volume element
dx = l(1)/N(1);
sigma = round(beamDia/dx);
center = [floor((N(1)+2)/2) floor((N(2)+2)/2)];
I(:,:,1) = gaussC(R,C, sigma, center);

%% Calculate transmission in z direction
for i=2:N(3)+1
    I(:,:,i) = I(:,:,i-1).*exp(-AC(:,:,i)*l(3)/N(3));
end

%% Plot intensity
figure
subplot(1,2,1)
xData = 0:l(3)/N(3):l(3);
yData = squeeze(I(center(1),center(2),2:end));
plot(xData,yData)
xlabel('Z [m]')
ylabel('I/I_0')
title('Intensity distribution in z direction')
subplot(1,2,2)
zData = I(:,:,1);
s = surf(zData);
s.LineStyle = 'none';
xlabel('X')
ylabel('Y')
zlabel('I/I_0')
xlim([2 N(1)+1])
ylim([2 N(2)+1])
zlim([0 inf])
view([0 90])
title('Intensity distribution in xy plane')

%% Calculate Absorption for every layer
% Preallocate array
A = zeros(size(I));
for i=2:N(3)+2
    % Absorption in Layer i
    A(:,:,i) = I(:,:,i-1) - I(:,:,i);
end
% Make first layer non absorbing
A(:,:,1) = 0; A(:,:,end) = 0;
A(:,1,:) = 0; A(:,end,:) = 0;
A(1,:,:) = 0; A(end,:,:) = 0;

% Normation
A = A/sum(A(:));

end

function val = gaussC(x, y, sigma, center)
xc = center(1);
yc = center(2);
exponent = ((x-xc).^2 + (y-yc).^2)./(2*sigma);
val       = (exp(-exponent));
end