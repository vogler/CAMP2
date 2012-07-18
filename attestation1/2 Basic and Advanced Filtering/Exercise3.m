%% Computer Aided Medical Procedures II - Summer 2012
%% Filtering
%% Exercise 3: Advanced filtering: anisotropic diffusion

clear all; close all; 

%%-----------------------------------------------------------------------%%
%% A. Create the shape logan phantom 512x512 (function phantom)
%% And add some normal noise
sx = 512; sy = 512; % Size of the image
SL = phantom(sx,sy);
SLn = SL + (0.25.*randn(sx, sy));
% SLn = imnoise(SL,'gaussian',0,0.0625);        % Built-in Matlab function
% for image noise

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
G_edge = fspecial('gaussian', 3, 0.5);
%Define sigma for edge indicator function
sigma = 0.25;

%%-----------------------------------------------------------------------%%
%% B. Iterative filtering

%% iterative filtering
for i = 1:steps
    
    %%% Isotropic diffusion filter
    % 1. compute right hand side of heat equation using grad and div
    % - our function
    %D_heateq =  div(grad(I_heateq));
    % - Matlab function
    [xdim ydim]=gradient(double(I_heateq));
    D_heateq =  divergence(xdim,ydim);
    
    % 2. forward Euler step for heat equation (see equation (3))
    I_heateq =  I_heateq + tau * D_heateq;
    
    %%% Anisotropic diffusion filter
    % 1. Compute right hand side of the gradient
    [dxI_edge dyI_edge] = grad(double(I_edge));
    
    % 2. Compute diffusion coefficient (see equation (5))
    % i. Filter the image with the gaussian  filter G_edge
    I_edge_smooth = imfilter(I_edge, G_edge, 'symmetric');
    
    % ii. Compute the respective gradient magnitude
    % - our function
    %[grad_x grad_y] = grad(double(I_edge_smooth));
    % - Matlab function
    [grad_x grad_y] = gradient(double(I_edge_smooth));
    Mag = sqrt(grad_x.^2 + grad_y.^2);      % gradient magnituede
    
    % iii. Compute the diffusion coefficient
    g   = 1./(1+(Mag/sigma)^2);      % using first formula of slide 35
    % Note: The parameter 'sigma' sets which edges should not be diffused
    % (x > sigma)
    % 2. Get the modified Laplacian
    % - our function
    %D_edge = div(g.*dxI_edge, g.*dyI_edge);
    % - Matlab function
    D_edge = divergence(g.*dxI_edge, g.*dyI_edge);
    % 3. forward Euler step for heat equation
    I_edge = I_edge + tau * D_edge;
    
    %%% Iterative median filter
    % 2. Filter the image I_median with a median filter of size 5x5 (imfilt2)
%     I_median = imfilt2(I_median, 2);
    I_median = medfilt2(I_median, [5 5]);
        
    %%% Display
    if mod(i,10)==1
        figure(1);
        disp(i)
        subplot(2,2,1); imagesc(SLn); axis image; axis off; colormap gray;...
            title('Original Image')
        subplot(2,2,2); imshow(I_heateq); axis image; axis off; colormap gray;...
            title('Isotropic Diffusion')
        subplot(2,2,3); imagesc(I_edge); axis image; axis off; colormap gray;...
            title('Anisotropic Diffusion')
        subplot(2,2,4); imagesc(I_median); axis image; axis off; colormap gray; ...
            title('Iterative Median Filtering')
        drawnow
    end
end