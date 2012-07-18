% Exercise 3: Basic image processing
clear
clc
close all

% a) Read the file mrihead.jpg
im = imread('mrihead.jpg');

% b) Visualize the image

% show image
imshow(im)


% my version
myFig = figure('Name', 'My plot of MRI head','NumberTitle','off');
axis([0 250 0 250])
imagesc(im)
colormap('Gray')

% c) visualize the left quarter range[100, 150]
myFig2 = figure('Name', 'My plot of MRI head, left upper corner','NumberTitle','off');
axis([0 100 0 150])
imagesc(im)
colormap('Gray')


% d) Image processing toolbox
myFig3 = figure('Name', 'My plot of MRI head with adapthisteq','NumberTitle','off');
axis([0 250 0 250])
imagesc(adapthisteq(im))
colormap('Gray')

% e) Smooth the image by a filter
myFig4 = figure('Name', 'My plot of MRI head with adapthisteq and filter','NumberTitle','off');
axis([0 250 0 250])
filter = fspecial('gaussian', [4 4], 0.5);
imagesc(imfilter(adapthisteq(im), filter ,'replicate'));
colormap('Gray')

% f) display differences
orig = double(im);
newImage = double(imfilter(adapthisteq(im), filter));

myFig5 = figure('Name', 'My plot ... differences');
axis([0 250 0 250])
imagesc(orig-newImage)
colormap('Gray')







