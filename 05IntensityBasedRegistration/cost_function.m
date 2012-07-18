%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function cost_function
% implement intensity based registration

function [similarity_value] = cost_function(transform_params, img_fixed, img_moving, similarity_measure)

global img_registertest

% construct current transformation
angle = transform_params(1);
dx    = transform_params(2);
dy    = transform_params(3);

%%% TODO:
% apply current transformation to img_moving
%   store result in "img_registertest"
img_registertest = image_rotate(img_moving, angle, [0 0]);
img_registertest = image_translate(img_registertest, [dx dy]);


N = dx*dy;
% calculate similarity measure
switch upper(similarity_measure)
    case 'SSD'
        %%% TODO:
        % calculate SSD
        similarity_value = sum(sum((img_fixed-img_registertest).^2))/N;
        
    case 'SAD'
        %%% TODO:
        % calculate SAD
        similarity_value = sum(sum(abs(img_fixed-img_registertest)))/N;
        
    case 'NCC'
        %%% TODO:
        % calculate NCC
        m1 = mean2(img_fixed);
        m2 = mean2(img_registertest);
        s1 = std2(img_fixed);
        s2 = std2(img_registertest);
        % TODO: somehow only returns 0, but formula seems to be correct
        similarity_value = -mean2((double((img_fixed-m1).*(img_registertest-m2)))./(s1*s2));
        
    case 'MI'
        %%% TODO:
        % calculate MI, use the function joint_histogram
        bins = 256;
        %histo = joint_histogram(img_fixed, img_registertest);
        %h1 = imhist(img_fixed, bins);
        %h2 = imhist(img_registertest, bins);
        %similarity_value = sum(sum(histo .* log(histo ./ (h1*h2')))); % h1*h2' right?
       
        p_xy = joint_histogram(img_fixed, img_registertest);
        p_x = hist(double(img_fixed(:)), bins);
        p_y = hist(double(img_registertest(:)), bins);
        tmp = zeros(bins);
        for i=1:bins
            for j=1:bins
                % check, if devision by zero occurs (results in NaN) and if the
                % log(...)-term gets zero (results in a -Inf)
                if(((p_x(i) * p_y(j)) ~= 0) && (p_xy(i,j)/(p_x(i)* p_y(j)) ~= 0))
                    tmp(i,j) = p_xy(i,j) * log(p_xy(i,j)/(p_x(i)* p_y(j)));
                end
            end
        end
        
        similarity_value = sum(tmp(:));
end;