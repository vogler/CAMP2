%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate joint histogram of 2 images

function [histo] = joint_histogram(img1, img2)

bins = 256;

histo = zeros(bins, bins);

%%% TODO:
% calculate the joint histogram of img1 and img2
%   and store it in histo

% h1 = imhist(img1, bins);
% h2 = imhist(img2, bins);
% a = repmat(h1, 1, bins);
% b = repmat(h2', bins, 1);
% histo = a + b;

for idx=1:numel(img1) % numel(img) = length(img(:))
   % i and j are the intensities for img1 and img2 at the pixel at idx
   i = round((double(img1(idx))/255)*bins); % get the pixel intensity and scale its value
   j = round((double(img2(idx))/255)*bins);

    if((i~=0) && (j~=0))
        histo(i,j) = histo(i,j) + 1;
    end
end

% show normalized histogram [0, 255]
% ih = histo-min(min(histo));
% ih = ih/max(max(ih))*255;
% imshow(ih);