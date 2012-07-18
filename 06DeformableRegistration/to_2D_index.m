function [x, y] = to_2D_index(s, n_elem)
% returns 2D coordinates cooresponding to the array entry s
% if the array was treated as a 2D matrix of n_elem(1) rows
% and n_elem(2) columns.

x = ceil(s / n_elem(1));
y = mod(s, n_elem(1));

if (y == 0) 
    y = n_elem(1);
end;