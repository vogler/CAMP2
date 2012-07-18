function D = div(v1,v2)
% D = div(v1,v2) computes the divergence of the vector-
% field (v1, v2)^T with backward differences assuming
% Neumann boundary conditions
%
% written by
% Maximilian Baust
% April 20th 2009
% Chair for Computer Aided Medical Procedures & Augmented Reality
% Technische Universit�t M�nchen

[m n] = size(v1);

dxv1 = zeros(m,n);
dyv2 = zeros(m,n);

ularger_right=padarray(v1,[0 1],'post');
ularger_left=padarray(v1,[0 1],'pre');
ularger_top=padarray(v2,[1 0],'pre');
ularger_bottom=padarray(v2,[1 0],'post');
%approximate the derivative of v1 in x-direction with backward differences
dxv1=ularger_left-ularger_right;

%approximate the derivative of v2 in y-direction with backward differences
dyv2=ularger_top-ularger_bottom;

%correct size
dxv1(:,1)=[];
dyv2(1,:)=[];
%correct boundary treatment
%otherwise we assume that also the "second derivative" is 0
dxv1(:,1) = v1(:,1);% - 0
dyv2(1,:) = v2(1,:);% - 0

%compute the divergence
%fin1=padarray(dxv1,[1 0],'post');
%fin2=padarray(dyv2,[0 1],'post');
%
D=dxv1+dyv2;
%D=size(dyv2);

