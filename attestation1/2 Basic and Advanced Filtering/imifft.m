function Y = imifft(X)

%% The function returns the inverse 2d fourier transform of the input image X
%% Hint: use the functions ifft2, ifftshift, and abs

% 1. Inverse FFT shift (ifftshift)
% 2. Inverse FFT (ifft2)
% 3. Use absolute value, because the resulting values can be complex
% ( sin(x) and cos(x) values )
Y = abs(ifft2(ifftshift(X)));
