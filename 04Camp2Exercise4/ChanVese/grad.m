function [dxu dyu] = grad(u)
% [dxu dyu] = grad(u) computes the gradient of the function u
% with forward differences assuming
% Neumann boundary conditions
%
% written by
% Maximilian Baust
% April 20th 2009
% Chair for Computer Aided Medical Procedures & Augmented Reality
% Technische Universität München

[m n] = size(u);

dxu = zeros(m,n);
dyu = zeros(m,n);

%approximate the derivative of u in x-direction with forward differences
dxu(:,1:(n-1)) =  u(:,2:n) - u(:,1:(n-1));

%approximate the derivative of u in y-direction with forward differences
dyu(1:(m-1),:) =  u(2:m,:) - u(1:(m-1),:);


