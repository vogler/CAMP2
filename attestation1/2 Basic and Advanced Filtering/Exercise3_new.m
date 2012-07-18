%% Computer Aided Medical Procedures II - Ss2010
%% Filtering
%% Exercise 3: Advanced filtering: anisotropic diffusion

clear all; close all; 

%%-----------------------------------------------------------------------%%
%% A. Create the shape logan phantom 512x512 (function phantom)
%% And add some normal noise
sx = 512; sy = 512; % Size of the image
SL = phantom(sx,sy);
SLn = SL + 0.25*randn(sx,sy);

% Make copies for all different outcomes
I_heateq = SLn;
I_edge = SLn;
I_median = SLn;

%% Define all parameters
%Define number of time steps
steps = 200;
%Define stepsize for time steps
tau = 0.05;
%Define Gaussian-kernels for edge stopping diffusion
G_edge = fspecial('gaussian',3,0.5);
%Define sigma for edge indicator function
sigma = 0.5;

%%-----------------------------------------------------------------------%%
%% B. Iterative filtering

%% iterative filtering
for i = 1:steps
    
    %%% Isotropic diffusion filter
    % 1. compute right hand side of heat equation using grad and div
    [dxI_heateq dyI_heateq] = grad(I_heateq);
    D_heateq =  div(dxI_heateq, dyI_heateq);
    % 2. forward Euler step for heat equation (see equation (3))
    I_heateq = I_heateq + tau*D_heateq;
    
    %%% Anisotropic diffusion filter
    % 1. Compute right hand side of the gradient
    [dxI_edge dyI_edge] = grad(I_edge);
    % 2. Compute diffusion coefficient (see equation (5))
    % i. Filter the image with the gaussian  filter G_edge
    I_edge_smooth = convn(I_edge, G_edge);
    % ii. Compute the respective gradient magnitude
    Mag = sqrt(dxI_edge.^2 + dyI_edge.^2);
    % iii. Compute the diffusion coefficient
    
    % I(x,t+1) = I(x,t) +  tau * div( c(x) * grad(I(x,t)) )
    % With c(x) = 1/(1+||grad(I(x,t))||^2/sigma^2) or c(x) = exp(-||grad(I(x,t))||^2/sigma^2)

    g   = exp(-(Mag.^2/sigma^2));% 1 ./ (1 +  (dxI_edge.^2)./(k.^2));
   % gy   = exp(-(dyI_edge.^2/sigma^2));% 1 ./ (1 + (dyI_edge.^2)./(k.^2));
    % 2. Get the modified Laplacian
    D_edge =  div(g .*dxI_edge, g .*dyI_edge);
    % 3. forward Euler step for heat equation
    I_edge = I_edge + tau * D_edge;
    
    %%% Iterative median filter
    % 2. Filter the image I_median with a median filter of size 5x5 (imfilt2)
    I_median = medfilt2(I_median, [5 5]);
        
    %%% Display
    if mod(i,10)==1
        figure(1);
        disp(i)
        subplot(2,2,1); imagesc(SLn); axis image; axis off; colormap gray;...
            title('Original Image')
        subplot(2,2,2); imagesc(I_heateq); axis image; axis off; colormap gray;...
            title('Isotropic Diffusion')
        subplot(2,2,3); imagesc(I_edge); axis image; axis off; colormap gray;...
            title('Anisotropic Diffusion')
        subplot(2,2,4); imagesc(I_median); axis image; axis off; colormap gray; ...
            title('Iterative Median Filtering')
        drawnow
    end
end