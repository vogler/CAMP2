%% Preparing the data

dim = 32; % data available for 32 and 64
image = phantom(dim);

% prepare a comparison FBP reconstruction
projections = 0:179;
sinogram = radon(image, projections);
% optional: add 5% normally distributed noise
% sinogram = sinogram + 0.05 * mean(sinogram(:)) * randn(size(sinogram));

filter = 'Ram-Lak';
reconFBP = fbp(sinogram, projections, filter);

figure(2), subplot(2, 2, 1); imagesc(image); axis equal; axis off; title(['Phantom, size ' num2str(dim)]);
figure(2), subplot(2, 2, 2); imagesc(reconFBP); axis equal; axis off; title(['FBP, filter ' filter]);


% load prepared system matrix
filename = ['Ab0', num2str(dim), '.mat'];
load(filename);


%% ART reconstruction

iterations = 25;
reconART = art(A, b, iterations);

figure(2), subplot(2, 2, 4); imagesc(reconART); axis equal; axis off; title(['ART, iter ' num2str(iterations)]);


%% Try out Matlab \ for fun

tic;
reconMatlab = A \ b;
reconMatlab = reshape(reconMatlab, dim, dim);
elapsed = toc;
disp(['Matlab done in ' num2str(elapsed) ' seconds.']);

figure(2), subplot(2, 2, 3); imagesc(reconMatlab); axis equal; axis off; title('Matlab \\');
