function [gradient_E,img_diff] = grad_energy(phi, R, T, d_ctrl, n_ctrl)

d = prod(n_ctrl); % n * m
n_img = size(R);
f = fspecial('sobel');
gradient_E = zeros(d*2, 1);

% Precompute terms of gradient that are identical 
% for all partial derivatives (product of difference image
% and image gradients of the template in x and y:

% Notes: T is already wrapped here, no need to wrap it
img_diff = R - T;

[gx  gy] = gradient(T);

forcex = img_diff .* gx;
forcey = img_diff .* gy;

for i=1:d % loop over control points
    % the index of the control point
    [cpIndexX cpIndexY] = to_2D_index(i, n_ctrl);
    
    % the pixel region, which has to be sampled
    minPixX = min(n_img(2), max(1, (cpIndexX - 2 - 2)*d_ctrl(2)));
    maxPixX = min(n_img(2), max(1, (cpIndexX - 2 + 2)*d_ctrl(2)));
    minPixY = min(n_img(1), max(1, (cpIndexY - 2 - 2)*d_ctrl(1)));
    maxPixY = min(n_img(1), max(1, (cpIndexY - 2 + 2)*d_ctrl(1)));

%     % Old approach based on loops 
%     iterate pixels
%     for px=minPixX:maxPixX 
%         for py=minPixY:maxPixY
%             tmpphi = phi;
%             tmpphi(i) = tmpphi(i) + 1;
%             tmpphi(i + d) = tmpphi(i + d) + 1;
%             [shiftx, shifty] = Txy(px, py, tmpphi, d_ctrl, n_ctrl);
%             [oldshiftx, oldshifty] = Txy(px, py, phi, d_ctrl, n_ctrl);
%             sumx = sumx + (shiftx - oldshiftx) * forcex(py, px);
%             sumy = sumy + (shifty - oldshifty) * forcey(py, px);
%         end
%     end

    % compute the "slightly shifted" phi
    shiftphi = phi;
    shiftphi(i) = shiftphi(i) + 1;
    shiftphi(i + d) = shiftphi(i + d) + 1;
    
    % create function pointers to Txy passing phi
    fh      = @(x, y) Txy(x, y, phi, d_ctrl, n_ctrl);
    % create function pointers to Txy passing the shifted phi
    fhShift = @(x, y) Txy(x, y, shiftphi, d_ctrl, n_ctrl);
    
    % generates two matrices - one with the x and one with the y
    % coordinates of the pixels which are sampled
    xparams = repmat(minPixX:maxPixX, maxPixY - minPixY + 1, 1);
    yparams = repmat((minPixY:maxPixY)', 1, maxPixX - minPixX + 1);
    
    % applies Txy to the pixels with phi and shift_phi respectively
    [resx, resy] = arrayfun(fh, xparams, yparams);
    [resx_s, resy_s] = arrayfun(fhShift, xparams, yparams);
    
    % the pixel offset
    res_diffx = resx_s - resx;
    res_diffy = resy_s - resy;
    
    % multiply the offset with the corresponding force value
    res_integralx = res_diffx .* forcex(minPixY:maxPixY, minPixX:maxPixX);
    res_integraly = res_diffy .* forcey(minPixY:maxPixY, minPixX:maxPixX);
    
    % integrate over all values
    sumx = sum(sum(res_integralx));
    sumy = sum(sum(res_integraly));
    
    gradient_E(i  ,1) = sumx / (sumx^2 + sumy^2)^0.5;
    gradient_E(i+d,1) = sumy / (sumx^2 + sumy^2)^0.5;
    

end