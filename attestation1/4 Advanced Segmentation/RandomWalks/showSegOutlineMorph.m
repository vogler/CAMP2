function showSegOutlineMorph( img, mask, width )
%SHOWSEGOUTLINEMORPH Segmentation outline based on morphological
%operations.
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation
%
%   This is more robust than using the gradient. The contour width can also
%   be specified.
if(width<=0)
    error('Width <=0');    
end
    

mask2 = mask;
mask2(mask2==2) = 0;
Dilate = bwmorph(mask2,'dilate');
for i=1:width
    Dilate = bwmorph(Dilate,'dilate');
end

Erode = bwmorph(mask2,'erode');
for i=1:width
    Erode = bwmorph(Erode,'erode');
end

border = zeros(size(mask));
border(Dilate) = 1;
border(Erode) = 0;

imgMarkup=img(:,:,1);
imgMarkup( border == 1) = 1;

imgTmp1=img(:,:,1);
imgTmp1(border == 1) = 0;
imgMarkup(:,:,2)=imgTmp1;
imgMarkup(:,:,3)=imgTmp1;
   
imgMarkup = (imgMarkup - min(imgMarkup(:)) ) ./ (max(imgMarkup(:)) - min(imgMarkup(:)));
figure;
%imshow(imgMarkup); %High res
imagesc(imgMarkup);
colormap('gray')
axis equal
axis tight
axis off



end

