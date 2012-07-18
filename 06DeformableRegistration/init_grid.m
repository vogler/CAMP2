function [n_ctrl, phi] = init_grid(d_ctrl, n_img)

n_ctrl(1) = ceil(n_img(1) / d_ctrl(1)) + 3;
n_ctrl(2) = ceil(n_img(2) / d_ctrl(2)) + 3;

phi = zeros(n_ctrl(1) * n_ctrl(2) * 2, 1);
offset =  n_ctrl(1)*n_ctrl(2);

for j=1:n_ctrl(1) 
    for i=1:n_ctrl(2)   
        
        index_x = ((i-1)*n_ctrl(1)) + j;
        index_y = ((i-1)*n_ctrl(1)) + j + offset;
        
        phi(index_x) = (i-2)*d_ctrl(2);
        phi(index_y) = (j-2)*d_ctrl(1);
    end;
end;
