function D = div(v1,v2)
% D = div(v1,v2) computes the divergence of the vector-
% field (v1, v2)^T with backward differences assuming
% Neumann boundary conditions
%
% written by
% Maximilian Baust
% April 20th 2009
% Chair for Computer Aided Medical Procedures & Augmented Reality
% Technische Universität München

[m n] = size(v1);

dxv1 = zeros(m,n);
dyv2 = zeros(m,n);

%approximate the derivative of v1 in x-direction with backward differences
dxv1(:,2:n) = v1(:,2:n) - v1(:, 1:(n-1));
% the first coloumn has zeros
% subtract the current column value (j) from the previous one (j-1)

%approximate the derivative of v2 in y-direction with backward differences
dyv2(2:m,:) = v2(2:m, :) - v2(1:(m-1), :);
% the first row has zeros
% subtract the current row value (i) from the previous one (i-1)

%correct boundary treatment
%otherwise we assume that also the "second derivative" is 0
dxv1(:,1) = v1(:,1);% - 0
dyv2(1,:) = v2(1,:);% - 0

%compute the divergence
D = dxv1 + dyv2;

