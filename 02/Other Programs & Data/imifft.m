function Y = imifft(X)

%% The function returns the inverse 2d fourier transform of the input image X
%% Hint: use the functions ifft2, ifftshift, and abs

Y = ifftshift(X);
Y = ifft2(Y);
Y = abs(Y);