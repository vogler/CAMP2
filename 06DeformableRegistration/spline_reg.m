function spline_reg()

% spline_reg.m: Exercise for simple deformable registration
% based on B-spline Free-form deformations. The algorithm 
% uses gradient descent and omits any regualrization for simplicity.

% Read reference (R) and template (T) images:
R = grayscale(imread('img_r.bmp'));
T = grayscale(imread('img_t.bmp'));

n_img = size(R);
n_iter = 10;
lambda = 5.0;

% Set control point spacing in x and y (in pixels):
d_ctrl = [40, 40];

% Initialize control point grid:
[n_ctrl, phi] = init_grid(d_ctrl, n_img);
d = prod(n_ctrl);

% Initialize warped template (T_u):
T_u = T;

for iter=1:n_iter
    fprintf('Iteration %d of %d.\n', iter, n_iter);
    fprintf('  SSD dissimilarity: %f\n', ssd(R, T_u));
    
    
    
    % Compute gradient of registration energy and normalize it:
    % YOUR CODE HERE
    
    % Apply update to the control points:
    % YOUR CODE HERE
    
    % Calculate displacement field:
    % YOUR CODE HERE
    
    % Warp template image:
    T_u = warp(T, u_x, u_y, n_img);



    % Display results of each iteration:
    figure(1);
    subplot(2,2,1);
    imshow(scale(R)); title('Reference Image');
    subplot(2,2,2);
    imshow(scale(T_u)); title('Deformed Template');
    subplot(2,2,3);
    imshow(scale(diff)); title('Difference');
    subplot(2,2,4);
    hold on;
    plot(phi(1:d), phi(d+1 : d*2), '+', 'Color', [1-iter/n_iter, iter/n_iter, 0]); title('Control Points');
    axis image;
    drawnow
end
