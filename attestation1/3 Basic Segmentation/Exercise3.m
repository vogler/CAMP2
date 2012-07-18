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
Image = imfilter(Image,fspecial('gaussian'));
fig = figure; imagesc(Image,[0 1]); axis image; colormap gray;axis off; ...
    axis xy

%% ----------------------------------------------------------------------%%
%% ----------------------------------------------------------------------%%
%% A. Basic Edge detection

%% 1. Compute the Magnitude of the gradient
[gx gy] = gradient(Image);
M = sqrt(gx.^2+gy.^2);%magnitude


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
Mn = M; %% Initialize the image with supressed non maxima edges
%% a. Compute the gradient direction
alpha = atan(gy./gx); %gradient direction
alpha_b = zeros(size(Image)); %pixel gradient direction

figure(fig+2); imagesc(alpha); axis image; colormap jet; axis off; ...
    title('Gradient Direction'); axis xy; colorbar
a = [0 45 90 135 180]; %% The 4 basic gradient directions (0=180)
for i = 2:s1-1
    for j = 2:s2-1
        %% Compute the nearest basic direction to the local gradient
        %% direction
        rad = alpha(i,j);
        
        if rad < 0 % only positive angles (0..180)
           rad = pi+rad; 
        end
        
        %[~,b] = min(abs(a-rad2deg(rad)));
        deg = rad/(2*pi)*360;
        [~,b] = min(abs(a-deg));
        
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
        %% And check if the gradient magnitude is is smaller than the
        %% gradient magnitude of one of its neighbours in the chosen
        %% direction. In this case, set it to zero in Mn.
        if M(i,j)<M(nd(1),nd(2)) || M(i,j)<M(ng(1),ng(2)) % non-maxima supression -> set to 0 if magnitude of one neighbor is bigger
            Mn(i,j)=0;
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
Th = 0.1;               %% high treshold
StrongPixel = Mn>Th;        %% Strong pixel map
% Create the weak pixel map
Tl = 0.02;               %% low treshold
WeakPixel = (Mn>Tl) & (Mn<=Th);
% Display
figure(fig+4); imagesc(StrongPixel); axis image; colormap gray; axis off; ...
    title('Strong Pixel'); axis xy
figure(fig+5); imagesc(WeakPixel); axis image; colormap gray; axis off; ...
    title('Weak Pixel'); axis xy
%%
figure(fig+6); imagesc(StrongPixel|WeakPixel); axis image; colormap gray; axis off; ...
    title('Strong & Weak Pixel'); axis xy
%Find the connected component (8-connectivity, use the function bwlabel)

[C, num] = bwlabel(StrongPixel|WeakPixel,8); % combine strong and weak and then label

% Compute the final edge map "EdgeCanny"
EdgeCanny = zeros(size(M)); %% Initialize
tmp = zeros(size(M));

% For every connected component, check if one of the pixels is a "strong
% pixel". In this case, set the whole component to be an edge.

for k = 1:num % for each component
    % strong pixel of component k:
    tmp = (C==k)&(StrongPixel==1); % strong pixels in component
    if max(max(tmp))>0 % is there a strong pixel in the component k?
        EdgeCanny = EdgeCanny|(C==k); %add the component to the final edge map
    end
end

%Display
figure(fig+7); imagesc(EdgeCanny); axis image; colormap gray; axis off; axis xy;...
    title('Final Canny output');


