% Exercise 4: Finite differences
clear
close all
clc

im = double(imread('mrihead.jpg'));

% a) Gradient
[dxim dyim] = grad(double(im));
D = div(dxim, dyim);

myFig = figure('Name', 'D = div(grad(im)','NumberTitle','off');
imagesc(D);
colormap('Gray')

myFig1 = figure('Name', 'Laplacian filter','NumberTitle','off');
imagesc(imfilter(im, [0 1 0; 1 -4 1; 0 1 0], 'replicate'))
colormap('Gray')

myFig2 = figure('Name', 'Diff = D - Laplacian','NumberTitle','off');
imagesc(D  - imfilter(double(im), [0 1 0; 1 -4 1; 0 1 0], 'replicate'))
colormap('Gray')

