function [gradient_E,diff] = grad_energy(phi, R, T, d_ctrl, n_ctrl)

d = prod(n_ctrl);
n_img = size(R);
f = fspecial('sobel');
gradient_E = zeros(d*2, 1);

% Precompute terms of gradient that are identical 
% for all partial derivatives (product of difference image
% and image gradients of the template in x and y:
% YOUR CODE HERE

for i=1:d

    % Compute parts of gradient that are not identical
    % for each of the partial derivatives (of E with respect
    % to each of the control points):
    % YOUR CODE HERE
    
    % gradient_E(i  ,1) = "x component";
    % gradient_E(i+d,1) = "y component";
end