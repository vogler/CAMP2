%% Exercise 3
%% Edge-Based segmentation methods
%% Gradient based / Basic, Canny

%% Clear and close everything
clear all; close all; clc;

%% ----------------------------------------------------------------------%%
%% ---------------------------------------------------------------------%%
%% Load the image
load('Image.mat')
Image = mat2gray(double(Image));
[s1 s2] = size(Image);

%% Filter the image with a Gaussian filter
Image = convn(Image, fspecial('gaussian'));
fig = figure; imagesc(Image,[0 1]); axis image; colormap gray;axis off; ...
    axis xy

%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% A. Basic Edge detection

%% 1. Compute the Magnitude of the gradient
[gx, gy] = gradient(Image);
M = sqrt(gx.^2 + gy.^2);

figure(fig+1); imagesc(M); axis image; colormap jet;axis off; ...
    title('Gradient Magnitude'); axis xy

%% Threshold the gradient
EdgeBasic = (M>0.1);
figure(fig+2); imagesc(EdgeBasic); axis image; colormap gray; axis off; ...
    title('Edge - Basic thresholding'); axis xy

disp('1 - pause')
pause
close(fig+2)


%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% B. CANNY

%% STEP1: Non Maxima suppression step
Mn = M .* EdgeBasic; %% Initialize the image with supressed non maxima edges
%% a. Compute the gradient direction
alpha = 180/pi * atan(gy./gx) + 90;
figure(fig+2); imagesc(alpha); axis image; colormap jet; axis off; ...
    title('Gradient Direction'); axis xy; colorbar
a = [0 45 90 135 180]; %% The 4 basic gradient directions (0=180)
for i = 2:s1-1
    for j = 2:s2-1
        %% Compute the nearest basic direction to the local gradient
        %% direction
        [v b] = min(abs(a - alpha(i, j)));
        %nearest = b;
        
        %% Just say that 0 and 180 should have the same index
        if b==5
            alpha_b(i,j) = 1;
        else
            alpha_b(i,j) = b;
        end
        
        %% Get the two neigbors in opposite directions
        % (4 possibilities)
        if alpha_b(i,j) == 1%0°
           nd = [i j-1];
           ng = [i j+1];
        elseif alpha_b(i,j) == 2%45°
           nd = [i+1 j+1];
           ng = [i-1 j-1];
        elseif alpha_b(i,j) == 3%90°
           nd = [i+1 j];
           ng = [i-1 j];
        elseif alpha_b(i,j) == 4%135%
           nd = [i+1 j-1];
           ng = [i-1 j+1];
        end
        %% And check if the gradient magnitude is smaller than the
        %% gradient magnitude of one of its neighbours in the chosen
        %% direction. In this case, set it to zero in Mn.
        if Mn(i, j) < Mn(nd(1), nd(2)) || Mn(i, j) < Mn(ng(1), ng(2))
            Mn(i, j) = 0;
        end
        
    end
end

%% Display
figure(fig+3); imagesc(Mn); axis image; colormap jet; axis off; ...
    title('Magnitude after Non maxima suppresion'); axis xy

%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% STEP2: Hysteresis

% Create the strong pixel map
Th = 0.15;               %% high threshold
StrongPixel = Mn>Th;        %% Strong pixel map
% Create the weak pixel map
Tl = 0.03;               %% low treshold
WeakPixel = (Mn>Tl) & (Mn<Th); % Matlab doesn't allow [0.3 0.3]
% Display
figure(fig+4); imagesc(StrongPixel); axis image; colormap gray; axis off; ...
    title('Strong Pixel'); axis xy
figure(fig+5); imagesc(WeakPixel); axis image; colormap gray; axis off; ...
    title('Weak Pixel'); axis xy

% Find the connected component (8-connectivity, use the function bwlabel)
C = bwlabel(StrongPixel|WeakPixel, 8);

% Compute the final edge map "EdgeCanny"
%EdgeCanny = zeros(size(M)); %% Initialize
EdgeCanny = StrongPixel;

% For every connected component, check if one of the pixels is a "strong
% pixel". In this case, set the whole component to be an edge
for k = 1:max(max(C))
    if sum(sum((C==k) & StrongPixel))>0
       EdgeCanny = EdgeCanny | (C==k);
    end
end

% Display
figure(fig+6); imagesc(EdgeCanny); axis image; colormap gray; axis off; axis xy;...
    title('Final Canny output');

figure(fig+7); imagesc(C); axis image; colormap jet; axis off; axis xy;...
    title('Connected components');


