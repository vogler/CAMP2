function [ X ] = featuresBinary( I, region_size )
%FEATURESBINARY Summary of this function goes here
%   Detailed explanation goes here
h = floor(region_size/2);
l = region_size^2-1;
filter = ones(region_size);
If = imfilter(I, filter/numel(filter), 'replicate');
If = padarray(If, [h+1 h+1], 'replicate');
X = zeros(size(I, 1), size(I, 2), l);
for i=1+h:size(I, 1)+h
    for j=1+h:size(I, 2)+h
        v = zeros(l, 1);
        vi = 1;
        for a=-h:h % build vector -> TODO: regions not pixels
            for b=-h:h
                if a == 0 && b == 0 % middle
                    continue;
                end
                v(vi) = If(i+a, j+b) < If(i, j);
                vi = vi+1;
            end
        end
        X(i-h, j-h, :) = v;
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

