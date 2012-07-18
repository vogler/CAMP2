function [ X ] = featuresMean( I, region_size )
%FEATURESMEAN Summary of this function goes here
%   Detailed explanation goes here
h = floor(region_size/2);
l = region_size^2;
filter = ones(region_size);
If = imfilter(I, filter/numel(filter), 'replicate'); % mean filter
If = padarray(If, [h+1 h+1], 'replicate'); % pad
X = zeros(size(I, 1), size(I, 2), l); % features
for i=1+h:size(I, 1)+h
    for j=1+h:size(I, 2)+h
        v = zeros(l, 1);
        vi = 1;
        for a=-h:h % build vector -> TODO: regions not pixels
            for b=-h:h
                v(vi) = If(i+a, j+b);
                vi = vi+1;
            end
        end
        X(i-h, j-h, :) = v; % set feature vector
    end
end
% X = X(:);
n = size(I, 1)*size(I, 2);
xi = 1;
Xt = zeros(n, l);
for i=1:size(I, 1)
    for j=1:size(I, 1)
        Xt(xi) = X(i, j);
        xi = xi+1;
    end
end
X = Xt;
end

