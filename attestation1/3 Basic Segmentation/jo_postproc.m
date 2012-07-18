%% Clear and close everything
clear all; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load and display the image
load('Image.mat')
Image = mat2gray(double(Image));
figure(1);imagesc(Image,[0 1]); axis image; colormap gray; axis xy; ...
    title('Original image'); axis off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q1: Automatically cluster the image with k-mean algoritm
m = [0 0.1 0.2 0.3]; %% Initialize the mean
figure(1); Image_km = kmeans(Image,m); %Fill "kmeans.m"


close all;
imagesc(Image_km);
pause(1);
close all;

%show only vesicles

%I_01 = zeros(size(Image_km));
I_01 = double(Image_km==2);
imagesc(I_01);
figure(2); imshow(I_01);

