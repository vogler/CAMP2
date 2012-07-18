%% Computer Aided Medical Procedures II - Summer 2012
%% Filtering
%% Exercise 4
%% Frangi filter

clear all; close all; clc; 

%% Read the image
I = imread('Vessel.png'); 
I = double(I(:,:,1)); % 2d uint8 -> 2d double

%% Set the Parameters
sigmas = [1:1:5]; % also equal to scale
beta  = 1; % unlike blob
c     = 100; % high structuredness

%% Create matrices to store all vesselness images, number: length(sigmas) (:,:,i)...
AllScale =zeros([size(I) length(sigmas)]);

%% Display the original image
figure(1); subplot(1,2,1); imagesc(I); axis image; colormap gray;axis off; title('Original');

% Frangi filter for all the scales sigma
for i = 1:length(sigmas)
    
    % 1. Calculate the 2D hessian for the scale sigmas(i)
    %% ToDo: Fill Hessian2D
    [Dxx,Dxy,Dyy] = Hessian2D(I,sigmas(i)); % 2 times gaussian derivatives
    
    % Correct for scale
    Dxx = (sigmas(i)^2)*Dxx;
    Dxy = (sigmas(i)^2)*Dxy;
    Dyy = (sigmas(i)^2)*Dyy;
    % Calculate eigenvalues and vectors and sort the eigenvalues
    [Lambda1,Lambda2]=eig2image(Dxx,Dxy,Dyy);

    % 2. Compute the similarity measures that make sense in 2D
    % and the corresponding vesselness measure
    Rb  = Lambda1./Lambda2;
    S   = Lambda1.^2+Lambda2.^2;
    Vesselness = exp(-Rb/(2*beta^2)).*(ones(size(I))-exp(-S/(2*c^2)));
    
    % 3. Set to Vesselness to 0 if Lambda2 is positive
    % and Store the results in the matrix AllScale
    %if Lambda2>0
    %    Vesselness=0;
    %end
    zeroCheck = Lambda2<0;
    Vesselness=Vesselness.*zeroCheck;
    AllScale(:,:,i) = Vesselness;
    
    figure(1); subplot(1,2,2); imagesc(Vesselness); axis image; colormap gray;axis off; title(sigmas(i));
    pause(1)
end

% 4. Which scale returns the higest vesselness value?
% Deduce the filtered image If
[s1 s2 s3]=size(AllScale);
% If = zeros(s1,s2);
% for i=1:s1
%     for j=1:s2
%         for k=1:s3 %iterates through scales      
%           vk(k)=AllScale(i,j,k); %store values of pixels ij in vector
%         end
%         If(i,j)=max(vk); %get maximum value
%     end
% end
If=max(AllScale,[],3); % maximum along 3rd dimension
% Display
figure(1); subplot(1,2,2); imagesc(If); axis image; ...
    colormap gray;axis off; title('Frangi filter');