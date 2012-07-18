function [ seeds labels ] = drawSeeds( fig, image_size, label )
%DRAWSEEDS Allow drawing of seeds onto figure h
%   Seed placement for Random Walks algorithm
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation

% Set active figure
figure(fig);
h = imfreehand('Closed',false);
% From selection to RW seeds
seed = round(getPosition(h));
labels = zeros(length(seed),1);
labels = labels + label;
seed = sub2ind(image_size,seed(:,2),seed(:,1));
seeds = unique(seed);
delete(h);
end

