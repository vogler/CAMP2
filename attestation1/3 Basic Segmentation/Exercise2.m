%% Exercise 2
%% Region-Based segmentation methods
%% Region Growing / Region Splitting

%% Clear and close everything
% clear all; close all; clc;

%% ---------------------------------------------------------------------%%
%% Load the image
load('Image.mat')
Image = mat2gray(double(Image));

%% ---------------------------------------------------------------------%%
%% A. REGION GROWING
%% Q1: Fill RegionGrowing.m
Image_RG = RegionGrowing(Image,0.2);
pause; 
close all


%% ---------------------------------------------------------------------%%
%% B. The following section is FACULTATIVE and will not be included in the EVALUATION
%% (BONUS POINT though)

%% REGION SPLITTING
%% NB: the Region Merging is not programmed

%% Initialization (Read Split.m beforehand)
t = 1;
R(t,1) = 1; R(t,2) = size(Image,1); R(t,3) = 1; R(t,4) = size(Image,2);
T = 0.1;
D = 10;
create = zeros(1,1e4);
already = -ones(1,1e4); already(t) = 0;
father = zeros(1,1e4);
son = zeros(1,1e4);
I0 = ones(size(Image));
figure(1); imagesc(Image); colormap gray; axis image; colormap gray; axis xy;

%% Q2: Fill RegionGrowing.m
[R I0]= Split(Image,R,t,T,D,create,already,father,son,I0);

%% ---------------------------------------------------------------------%%
