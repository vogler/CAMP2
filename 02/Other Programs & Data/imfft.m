function Y = imfft(X)

%% The function returns the 2d fourier transform of the input image X
%% Hint: use the functions fft2, fftshift

Y = fft2(X);
Y = fftshift(Y);