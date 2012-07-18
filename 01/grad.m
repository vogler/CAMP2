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
%---- to be implemented ----

%approximate the derivative of u in y-direction with forward differences
%---- to be implemented ----


