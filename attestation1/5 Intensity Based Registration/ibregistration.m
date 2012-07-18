%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test script for intensity based registration algorithms
%
% Copyright, CAMP, Technische Universit�t M�nchen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ibregistration
%%
clear all;
close all;

disp('starting intensity based registration...');
tic;

% setting globals:
global img_registertest
global sval

% loading data
img_moving = imread('crossM.bmp');
img_fixed  = imread('crossF.bmp');
% img_moving = imread('ct_moving.png');
% img_fixed  = imread('crossF.png');

% setup registration parameters
initial_params     = [15 1 1];      % [angle translatex translatey]
similarity_measure = 'SSD';         % SSD, SAD, NCC or MI
iterSimplex = 0;

% prepare plotting
fig = figure();
subplot(2,2,1);
imagesc(img_fixed); colormap gray;
title('Fixed Image');
subplot(2,2,2);
imagesc(img_moving); colormap gray;
title('Moving Image');
subplot(2,2,3);
imagesc(img_fixed-img_moving); colormap gray;

%% do registration
disp(['  registration using ' similarity_measure]);

%%% TODO
% Optimizer 
% Read it carefully and understand what happens. 

options = optimset('OutputFcn', @outfun);
fh = @(x) cost_function(x, img_fixed, img_moving, similarity_measure);

[transform_params, min_value, exitflag] = fminsearch(fh,initial_params,options);

%% output function
function stop = outfun(x, optimValues, state, varargin)
    stop=false;
    iterSimplex = iterSimplex+1;
    
    figure(fig);
    subplot(2,2,2);
    imagesc(img_registertest); colormap gray;
    title('Moving Image');
    
    subplot(2,2,3);
    imagesc(double(img_fixed)-double(img_registertest)); colormap gray;
    title(['Difference Image: SV: ' num2str(optimValues.fval)]);
    
    subplot(2,2,4);
    sval(iterSimplex)=optimValues.fval;
    plot(1:iterSimplex,sval)
    title(['Iteration Step: ' num2str(iterSimplex)]);
end

if exitflag ~= 1
    error('Maximum iterations reached!')
end

disp('done with registration');
toc;

disp(['optimization returned minimum value of ' num2str(min_value)]);

% apply resulting transformation
angle = transform_params(1);
dx    = transform_params(2);
dy    = transform_params(3);
disp(['resulting rotation angle = ' num2str(angle) ', dx = ' num2str(dx) ', dy = ' num2str(dy)]);
disp(' ');

%%% TODO:
% apply resulting transformation to img_moving
%   store result in "img_registered"
img_registered = image_rotate(img_moving, angle, [0 0]);
img_registered = image_translate(img_registered, [dx dy]);


% display results
figure;
subplot(2, 3, 1);
imshow(img_fixed);
title('Original (fixed) image');

subplot(2, 3, 2);
imshow(img_moving);
title('Unregistered (moving) image');

subplot(2, 3, 3);
imshow(img_registered);
title('Registered image');

subplot(2, 3, 5)
imshow(abs(img_fixed-img_moving));
title('difference fixed-moving');

subplot(2, 3, 6);
imshow(abs(img_fixed-img_registered));
title('difference fixed-registered');

end