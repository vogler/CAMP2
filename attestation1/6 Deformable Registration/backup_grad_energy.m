function [gradient_E,img_diff] = grad_energy(phi, R, T, d_ctrl, n_ctrl)

d = prod(n_ctrl);
n_img = size(R);
f = fspecial('sobel');
gradient_E = zeros(d*2, 1);

% Precompute terms of gradient that are identical 
% for all partial derivatives (product of difference image
% and image gradients of the template in x and y:

% Notes: T is already wrapped here, no need to wrap it
img_diff = T - R;

[gx  gy] = gradient(T);

forcex = img_diff .* gx;
forcey = img_diff .* gy;

%compute the symbolic functions
syms u1;
syms u2;
syms cp;
for symI=1:4
    for symJ=1:4
        symbFuncs(symI, symJ) = diff(spline_basis(symI-1, u1) * spline_basis(symJ-1, u2) * cp, cp);
    end
end
% symbFuncs1 = [spline_basis(0, u1) spline_basis(1, u1) spline_basis(2, u1) spline_basis(3, u1)];
% symbFuncs2 = [spline_basis(0, u2) spline_basis(1, u2) spline_basis(2, u2) spline_basis(3, u2)];
% symbFunc2 = spline_basis(2, u);
% symbFunc3 = spline_basis(3, u);
% symbFunc4 = spline_basis(4, u);
syms controlPoint;


for i=1:d
    
    [cpIndexX cpIndexY] = to_2D_index(i, n_ctrl);
    cpPixelX = phi(i);
    cpPixelY = phi(i + d);
    
    debug_img = zeros(n_img(1), n_img(2));
    %iterate over regions
    for l=1:4 
        for m=1:4
            % iterate pixels
            for px=1:d_ctrl(2)
                for py=1:d_ctrl(1)
                    absPx = cpPixelX - (3 - l) * d_ctrl(2) + px;
                    absPy = cpPixelY - (3 - m) * d_ctrl(1) + py;
                    
                    if(absPx > 1 && absPy > 1 && absPx < n_img(2) && absPy < n_img(1))
%                         index = ((is+l+1)-1) * n_ctrl(1) + js+m+1;

                        s = spline_basis(4 - l, px/d_ctrl(2)) * spline_basis(4 - m, py/d_ctrl(2));
                        debug_img(absPy, absPx) = s;
%                         res_x = res_x + s * phi(index);
%                         if (index+offset < size(phi,1))
%                             res_y = res_y + s * phi(index + offset);
%                         end
                    end
                end
            end
        end
    end
    imshow(debug_img);
%     % Compute parts of gradient that are not identical
%     % for each of the partial derivatives (of E with respect
%     % to each of the control points):
%     
%     % computing the influence of a control point, taking into consideration
%     % the pixels which are "moved" by this control point
%     
%     
%     % compute which regions are affected by the control point
% %     minpi = max(1, cpIndexX - 2);
% %     maxpi = min(n_ctrl(2), cpIndexX + 1);
% %     minpj = max(1, cpIndexY - 2);
% %     maxpj = min(n_ctrl(1), cpIndexY + 1);
% 
%     debug_img = zeros(d_ctrl(1)*4, d_ctrl(2)*4);
%     sumx = 0;
%     sumy = 0;
%     for pi=3:3
%         for pj=3:3
%             %compute the pixel domain of the region
%             minpixX = max(1, cpPixelX - (2 - pi)*d_ctrl(2));
%             maxpixX = max(1, min(n_img(2), cpPixelX - (1 - pi)*d_ctrl(2)));
%             minpixY = max(1, cpPixelY - (2 - pj)*d_ctrl(1));
%             maxpixY = max(1, min(n_img(1), cpPixelY - (1 - pj)*d_ctrl(1)));
%             
%             
%             
%             % traverse all pixels
%             for pixX=minpixX:maxpixX
%                 for pixY = minpixY:maxpixY
%                     ux = (pixX - cpPixelX) / d_ctrl(2);
%                     uy = (pixY - cpPixelY) / d_ctrl(1);
%                     fun = symbFuncs(5 - pi, 5 - pj);
%                     debug_img(pixY - minpixY, pixX - minpixX) = subs(subs(fun, u1, ux), u2, uy);
%                 end
%             end
            
            
%             % partition the pixel coordinates into i/j and u1/u2
%             partX = floor((px - cpPixelX) / d_ctrl(2));
%             partY = floor((py - cpPixelY) / d_ctrl(1));
%             u1param = (px - cpPixelX) / d_ctrl(2) - partX;
%             u2param = (py - cpPixelY) / d_ctrl(1) - partY;
%             partX = partX + 2;
%             partY = partY + 2;
%             
%             symbFunc = symbFuncs1(partX) * symbFuncs2(partY) * controlPoint;
%             symbFuncGrad = diff(symbFunc, controlPoint);
%             sumx = sumx + forcex(py, px) * subs(subs(symbFuncGrad, u1, u1param), u2, u2param);
%         end
%     end
%     sumx = sumx/prod(n_img);
%     sumy = sumy/prod(n_img);
%     imshow(debug_img);
%     
%     ctrl_pt_x = phi(i);
%     ctrl_pt_y = phi(i + d);
%     
%     sumx = 0;
%     sumy = 0;
%     for pixel_x = minx:maxx;
%         for pixel_y = miny:maxy
%             [destx desty] = Txy(pixel_x, pixel_y, phi, d_ctrl, n_ctrl);
%             sumx = sumx + destx;
%             sumy = sumy + desty;
%         end
%     end
%     
%     gradient_E(i  ,1) = sumx;
%     gradient_E(i+d,1) = sumy;
end