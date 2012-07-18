%% Preparing the data

dim = 256;
image = phantom(dim);
% image = imnoise(image, 'gaussian');

projections = 0:179;
sinogram = radon(image, projections);

% optional: add 5% normally distributed noise
% sinogram = sinogram + 0.05 * mean(sinogram(:)) * randn(size(sinogram));

figure(1), subplot(2, 2, 1); imagesc(image); axis equal; axis off; title(['Phantom, size = ', num2str(dim)]);
figure(1), subplot(2, 2, 2); imagesc(sinogram); axis equal; axis off; title('Sinogram');


%% Direct Fourier Reconstruction

interpolation = 'cubic';
reconFourier = fourier(sinogram, interpolation);

figure(1), subplot(2, 2, 3); imagesc(reconFourier); axis equal; axis off; title(['Fourier, interp ' interpolation]);


%% Filtered Backprojection
ani = 1;
filter = 'Ram-Lak';
if ani==0
    reconFBP = fbp(sinogram, projections, filter);
    figure(1), subplot(2, 2, 4); imagesc(reconFBP); axis equal; axis off; title(['FBP, filter ' filter]);
else
    for p=10:10:180
        projections = 0:p-1;
        sinogram = radon(image, projections);
        reconFBP = fbp(sinogram, projections, filter);
        figure(1), subplot(2, 2, 4); imagesc(reconFBP); axis equal; axis off; title(['FBP (' num2str(p) '), filter ' filter]);
        pause(0.1);
    end
end
