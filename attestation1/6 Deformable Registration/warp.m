function img_new = warp(T, displace_x, displace_y, n_img)

img_new = zeros(n_img);
T_temp = reshape(T, n_img);

for j=1:n_img(1)
    for i=1:n_img(2)
        
        dy = displace_y(j, i);
        dx = displace_x(j, i);
                   
%         if (j + dy > 0 && j + dy < n_img(1) && i + dx > 0 && i + dx < n_img(2))
%             img_new(j, i) = T_temp(j + dy, i + dx);    
%         else
%             img_new(j, i) = 0; %R(j, i);
%         end;

        img_new(j,i) = get_bilinear(T_temp, i+dx, j+dy);
    end;
end;