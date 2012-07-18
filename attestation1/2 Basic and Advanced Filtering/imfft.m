function Y = imfft(X)

%% The function returns the 2d fourier transform of the input image X
%% Hint: use the functions fft2, fftshift

% fftshift - Shift zero-frequency component to center of spectrum
Y = fftshift(fft2(X));
 