function [res_x, res_y] = Txy(x, y, phi, d_ctrl, n_ctrl)

i_temp = x/d_ctrl(2);
j_temp = y/d_ctrl(1);

is = floor(i_temp)-1;
js = floor(j_temp)-1;

u = i_temp - floor(i_temp);
v = j_temp - floor(j_temp);

offset = (n_ctrl(1)*n_ctrl(2));

res_x = 0;
res_y = 0;

for l=1:4 
    for m=1:4
        index = ((is+l+1)-1) * n_ctrl(1) + js+m+1;
       
        s = spline_basis(l-1, u) * spline_basis(m-1, v);
                
        res_x = res_x + s * phi(index);
        if (index+offset < size(phi,1))
            res_y = res_y + s * phi(index + offset);
        end
    end
end