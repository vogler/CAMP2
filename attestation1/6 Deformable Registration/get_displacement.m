function [ u_x , u_y ] = get_displacement( phi , d_ctrl , n_ctrl , n_img )
% returns the displacement array, which warps an image according to the
% given parameters:
% phi - control points
% d_ctrl - b-spline degree
% n_img - image size
% (a 2d vector)

u_x = zeros(n_img);
u_y = zeros(n_img);

for i = 1:n_img(2)
    for j = 1:n_img(1)
        [dixp_x disp_y] = Txy(i, j, phi, d_ctrl, n_ctrl);
        u_x(j, i) = i - dixp_x;
        u_y(j, i) = j - disp_y;
     end
end

end

