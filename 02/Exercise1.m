%% Computer Aided Medical Procedures II - Summer2012
%% Filtering

%% Exercise 1: Basic filtering in the spatial domain

clear all; close all; 

%%-----------------------------------------------------------------------%%
%% A. Create the shape logan phantom 512x512 
sx = 512; sy = 512; % Size of the image
SL = phantom(sx,sy);
%% And add some normal noise, with standard deviation of 0.25 and 0 mean (randn)
SLn = SL + 0.25 * randn(sx, sy);
%imshow(SL);
%imshow(SLn);

%%-----------------------------------------------------------------------%%
%% B. Smoothing
%% B.1. Create the average filter M_a of size 2*N+1, with N ranging from 1 to 5
%% And define the bordering conditions set to 'mirror';
%% Apply the filter to the noisy version of the image using convn
%% And compare the output SLn_f to the original image
disp('1.1 Average Smoothing')
figure(1); subplot(2,2,1); imagesc(SL); axis image; ...
    colormap gray; axis off; title('Original')
figure(1); subplot(2,2,2); imagesc(SLn); axis image; ...
    colormap gray; axis off; title('Corrumpted')
for N = 1:5
    M_a     = 1/(2*N+1)^2 * ones(2*N+1);         %% Average Mask
    %SLn_a   = imfilter(SLn, M_a, 'symmetric');         %% Filtered SLn
    SLn_a   = convn(SLn, M_a);         %% Filtered SLn
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
disp('1.2 Gaussian Smoothing')
for sigma = 1:10
    M_g     = fspecial('gaussian', 11, sigma);      %% Gaussian Mask
    SLn_g   = convn(SLn, M_g);      %% Filtered SLn
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
%M_x = [1, 0, -1];              %% Mask gradient x direction
M_x = fspecial('sobel');
%M_y = [-1, 0, 1]';             %% Mask gradient y direction
M_y = M_x';
for sigma = 0:10
    if sigma>0
        M_g = fspecial('gaussian', 11, sigma);      %% Gaussian Mask
        SLn_g = convn(SLn, M_g);    %% Filtered SLn
    else
        SLn_g=SLn;  %% No Filter
    end
    G_x = convn(SLn_g, M_x);          %% Gradient in x direction
    G_y = convn(SLn_g, M_y);          %% Gradient in y direction
    Mag = (G_x.^2 + G_y.^2).^0.5;          %% Gradient Magnitude
    Angle = atan(G_y./G_x);        %% Gradient Angle
    figure(2);
    subplot(2,2,1); imagesc(G_x); axis image; colormap gray; axis off; title('Gx')
    subplot(2,2,2); imagesc(G_y); axis image; colormap gray; axis off; title('Gy')
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
M_lap = fspecial('laplacian');        %% Laplacian Maks
Lap = convn(SLn, M_lap);              %% Filter SLn
figure(3); subplot(1,2,1); imagesc(Lap); axis image; colormap gray; axis off; title('Lap')
for k = 1:10
    M_log = fspecial('log', 5, k);        %% Log Mask 
    LoG = convn(SLn, M_log);          %% Filter SLn
    figure(3); subplot(1,2,2); imagesc(LoG); axis image; colormap gray; axis off; title(['LoG' num2str(k)])
    pause(0.5);
end
disp('End Exercise 1')
