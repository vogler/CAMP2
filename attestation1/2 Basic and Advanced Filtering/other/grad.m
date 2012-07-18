function [dxu dyu] = grad(u)
% [dxu dyu] = grad(u) computes the gradient of the function u
% with forward differences assuming
% Neumann boundary conditions
%
% written by
% Maximilian Baust
% April 20th 2009
% Chair for Computer Aided Medical Procedures & Augmented Reality
% Technische Universit�t M�nchen

[m n] = size(u);

dxu = zeros(m,n);
dyu = zeros(m,n);
ularger_right=padarray(u,[0 1],'post');
ularger_left=padarray(u,[0 1],'pre');
ularger_top=padarray(u,[1 0],'pre');
ularger_bottom=padarray(u,[1 0],'post');
%approximate the derivative of u in x-direction with forward differences
%---- to be implemented ----
dxu_pre=ularger_right-ularger_left;
dxu_pre(:,end)=[];
dxu=dxu_pre;
%approximate the derivative of u in y-direction with forward differences
%---- to be implemented ----
dyu_pre=ularger_bottom-ularger_top;
dyu_pre(end,:)=[];
dyu=dyu_pre;

