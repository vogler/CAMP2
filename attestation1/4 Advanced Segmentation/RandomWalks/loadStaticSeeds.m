function [ seeds labels ] = loadStaticSeeds(  )
%LOADSTATICSEEDS Load predefined seeds from files
%   For demonstration purpose and if Image Processing Toolbox not available
%   Seed placement for Random Walks algorithm
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation
FG = im2double(imread('CTAbdomenForeground.png'));
seedsFG = find(FG<=0);
labelFG = zeros(length(seedsFG),1);
labelFG = labelFG + 1;

BG = im2double(imread('CTAbdomenBackground.png'));
seedsBG = find(BG<=0);
labelBG = zeros(length(seedsBG),1);
labelBG = labelBG + 2;

seeds = [seedsFG; seedsBG];
labels = [labelFG; labelBG];

end

