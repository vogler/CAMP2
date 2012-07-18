%% Computer Aided Medical Procedures II - Summer2012
%% Filtering

%% Exercise 1: Basic filtering in the spatial domain

clear all; close all; 

%%-----------------------------------------------------------------------%%
%% A. Create the shape logan phantom 512x512 
sx = 512; sy = 512; % Size of the image
SL = phantom(sx,sy);

%% And add some normal noise, with standard deviation of 0.25 and 0 mean (randn)
SLn = SL + (0.25 .* randn(sx, sy));

%%-----------------------------------------------------------------------%%
%% B. Smoothing
%% B.1. Create the average filter M_a of size 2*N+1, with N ranging from 1 to 5
%% And define the bordering conditions set to 'mirror';
%% Apply the filter to the noisy version of the image using convn
%% And compare the output SLn_f to the original image

% The average filter is smoothing filter.
disp('1.1 Average Smoothing')
figure(1); subplot(2,2,1); imagesc(SL); axis image; ...
    colormap gray; axis off; title('Original')
figure(1); subplot(2,2,2); imagesc(SLn); axis image; ...
    colormap gray; axis off; title('Corrumpted')
for N = 1:5
    M_a     = (1/((2*N+1)^2)) * ones(2*N+1);        %% Average Mask (normalized)
    
    SLn_help = createBorderCond(SLn, N, 'mirror');  % Apply border condition
    SLn_filtered = convn(SLn_help, M_a, 'same');    %% Filter image with the average filter mask
    SLn_a = SLn_filtered(N+1:N+sx, N+1:sy+N);       % Reshape filtered SLn to original size
    
    figure(1); 
    subplot(2,2,3); imagesc(SLn_a); axis image; ...
        colormap gray; axis off; title(['Average Filter - N = ' num2str(N)]);
    subplot(2,2,4); imagesc(SLn_a(101:200,101:200)); axis image; ...
        colormap gray; axis off; title(['Average Filter - N = ' num2str(N)]);
    pause(0.5)
end
input('Continue?')

%% B.2 Repeat the operation with Gaussian filters of standard deviation
%% ranging from 1 to 10 with a step of 1;
% Gaussian filter is a low pass
% Reduces the noice in homogeneous regions, but blurs the edges (smoothing
% filter)
disp('1.2 Gaussian Smoothing')
kernelSize = 5;
for sigma = 1:10
    % Choice 1: Varying filter size (by sigma)
    M_g     = fspecial('gaussian', sigma*2+1, sigma);      %% Gaussian Mask (low pass)
    kernelSize = sigma;
    
    % Choice 2: Fixed filter size
    %kernelSize = 5;
    %M_g       = fspecial('gaussian', kernelSize, sigma);     % fixed filter size

    SLn_help = createBorderCond(SLn, kernelSize, 'mirror');      % Apply border condition
    SLn_filtered = convn(SLn_help, M_g, 'same');                 %% Filter image with gaussian filte SLn
    SLn_g = SLn_filtered(kernelSize+1:kernelSize+sx, kernelSize+1:sy+kernelSize);       % Reshape filtered SLn to original size
    
    figure(1); subplot(2,2,3); imagesc(SLn_g); axis image; colormap gray; ...
        axis off; title(['Gaussian Filter - Std = ' num2str(sigma)])
    figure(1); subplot(2,2,4); imagesc(SLn_g(101:200,101:200)); axis image; ...
        colormap gray; axis off; title(['Gaussian Filter - Std = ' num2str(sigma)])
    pause(0.5);
end
input('Continue?')

%%-----------------------------------------------------------------------%%
%% C. Edge
%% - Create the filters M_x and M_y corresponding to the two first order 
%% spatial derivatives
%% - Apply them to SLn to obtain G_x and G_y, to compute the gradient magnitude
%%   and the angle
%% - Repeat for SLn_g (sigma = 1:10)
%% - Comment
disp('2.1 Gradient Filter')
M_x = 1/2 * [0 0 0; 1 0 -1; 0 0 0];     %% Mask gradient x direction (normalized)
% M_x = [1 0 -1];                       %% Mask gradient x direction
M_y = 1/2 * [0 1 0; 0 0 0; 0 -1 0];     %% Mask gradient y direction (normalized)
% M_y = [-1 0 1]';                      %% Mask gradient y direction
for sigma = 0:10
    if sigma>0
        M_g = fspecial('gaussian', sigma*2+1, sigma);      %% Gaussian Mask
        SLn_help = createBorderCond(SLn, sigma, 'mirror');
        SLn_filtered = convn(SLn_help, M_g, 'same');                    %% Filtered SLn
        SLn_g = SLn_filtered(sigma+1:sigma+sx, sigma+1:sy+sigma);       % Reshape filtered SLn to original size
    else
        SLn_g=SLn;  %% No Filter
    end
    
    G_x = convn(SLn_g, M_x, 'same');          %% Gradient in x direction
    G_y = convn(SLn_g, M_y, 'same');          %% Gradient in y direction
    Mag = sqrt(G_x.*G_x + G_y.*G_y);          %% Gradient Magnitude
    Angle = atan(G_y./G_x);                   %% Gradient Angle
    
    figure(2);
    subplot(2,2,1); imagesc(G_x); axis image; colormap Gray; axis off; title('Gx')
    subplot(2,2,2); imagesc(G_y); axis image; colormap Gray; axis off; title('Gy')
    subplot(2,2,3); imagesc(Mag); axis image; colormap jet; axis off; title('Magnitude')
    subplot(2,2,4); imagesc(Angle); axis image; colormap jet; axis off; title('Angle')
    pause(0.5)
end
input('Continue?')

%% - Create the Laplacian filter M_lap
%% - Apply it to SLn
%% - Apply the LoG operator with standard deviation ranging from 0 
%% to 10 with a step of 1 (fspecial);Display the result LOG in the
%% subplot(1,2,2) of figure(3);
M_lap = [0 1 0; 1 -4 1; 0 1 0];            %% Laplacian Mask
maskSize = size(M_lap,1);
Lap = imfilter(SLn, M_lap, 'symmetric', 'conv');        % Matlab - built in function to perform image filtering with selectable border condition

figure(3); subplot(1,2,1); imagesc(Lap); axis image; colormap gray; axis off; title('Lap')
for k = 1:10
    M_log = fspecial('log', k*k+1, k);        %% Log Mask 
    LoG = imfilter(Lap, M_log, 'symmetric', 'conv');          %% Filter SLn
    figure(3); subplot(1,2,2); imagesc(LoG); axis image; colormap gray; axis off; title(['LoG' num2str(k)])
    pause(0.5);
end
disp('End Exercise 1')
clear all;
