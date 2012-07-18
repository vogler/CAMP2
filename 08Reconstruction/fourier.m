% direct fourier reconstruction
function recon = fourier(sinogram, interpolation)

tic;

[rows cols] = size(sinogram);

% calculate 1D FFT of the sinogram
fftSino = fftshift(fft(ifftshift(sinogram))); % ifftshift b/c of radon?

% prepare the coordinate system change
cartesianX = 0:1/(cols-1):1; % why not -1..1?
cartesianY = -1:2/(rows-1):1;

[x y] = meshgrid(-1:2/(rows-1):1);
ySign = y < 0;
polarAngle = ~ySign - atan2(y, x) / pi; % y>=0
polarRadius = sqrt(x.^2 + y.^2) .* (ySign - ~ySign);

% perform coordinate system change
fftSinoInterp = interp2(cartesianX, cartesianY, fftSino, polarAngle, polarRadius, interpolation, 0); % ZI = interp2(X,Y,Z,XI,YI)

% calculate 2D inverse FFT
recon = abs(fftshift(ifft2(ifftshift(fftSinoInterp)))); % wat?

% crop to half the size of image diagonal
crop = floor( rows/2/sqrt(2) ) - 1;
center = ceil( rows/2 );
recon = recon( 1+center-crop:center+crop, 1+center-crop:center+crop );

elapsed = toc;
disp(['Fourier done in ' num2str(elapsed) ' seconds.']);
