%% Exercise 1
%% Pixel-Based segmentation methods
%% Histogram / Manual thresholding / Kmean

%% Clear and close everything
clear all; close all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load and display the image
load('Image.mat')
Image = mat2gray(double(Image));
figure(1);imagesc(Image,[0 1]); axis image; colormap gray; axis xy; ...
    title('Original image'); axis off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q0: Display the histogram of "Image", using hist (100 bins) 
figure(2);hist(Image(:),100);

input('1 - pause');
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Threshold the image
T = [0.085 0.3 0.5 0.7]; %% Thresholds
T = [0 T Inf];      
Image_s = zeros(size(Image));
figure(1);hist(Image(:),100);axis ([0 1 0 3000]);title('Histogram')
for k = 1:length(T)-1
    figure(1);hold on; plot(T(k+1)*ones(1,1000),1:1000,'r','Linewidth',2); hold off;
    Image_s(((Image>T(k)).*(Image<=T(k+1)))==1)=k; % set values >T(k) and <=T(k+1) to k
    pause(0.1)
end
figure(2); imagesc(Image_s); axis image; axis xy; title('Manual Clustering');...
    axis off; colormap jet;

input('2 - pause');
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q1: Automatically cluster the image with k-mean algoritm
m = [0 0.1 0.2 0.3]; %% Initialize the mean
figure(1); Image_km = kmeans(Image,m); %Fill "kmeans.m"

input('3 - pause')
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Robustness to noise?
n = 0.02; % std of the gaussian noise
Image_n = imnoise(Image,'gaussian',0,n); % Add some noise to "Image"
figure(1);imagesc(Image_n,[0 1]); axis image; colormap gray; axis xy; title('Corrumpted image');
figure(2);hist(Image_n(:),100);axis ([0 1 0 3000]); title('Histogram of the Corrumpted image');

input('4 - pause')
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q2: Preprocess the image with the simplest filter possible (Gaussian) of std = 1.5;
Image_nf = imfilter(Image_n,fspecial('gaussian',11,1.5),'replicate'); % Filtered version of "Image_n"
figure(1);imagesc(Image_nf,[0 1]); axis image; colormap gray; axis xy
figure(2);hist(Image_nf(:),100);axis ([0 1 0 3000]);
figure(3);Image_nf_km = kmeans(Image_nf,m); % Apply the kmean algo to the filtered image

input('5 - pause')
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q3: Select the cluster corresponding to the lower brain vesicle
%% Post process the image to remove false negatives and false positives
%% after selecting the class to which the vesicles belong
%se = strel([0 1 0; 1 1 1;0 1 0]);
se = strel([1 1 1]);

I_pp = double(Image_nf_km==2); % cluster containing lower brain vesicle
%I_er = imerode(I_pp,se);
%I_di = imdilate(I_er,se);

Image_PostProcess = imopen(imclose(I_pp,se),se);
imshow(Image_PostProcess);

input('6 - pause')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Q4: Compute the connected components of the binary image "Image_PostProcess"
%% Fill "ConnectedComponents.m"
ConnectedComponents(Image_PostProcess,Image);

input('END of Exercise 1') 
close all
