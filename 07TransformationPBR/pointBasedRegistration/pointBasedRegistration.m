% pointBasedRegistration - returns the transformation from srcPts to dstPts. 
% 
% The transformation from the srcPts coordinate frame into the dstPts
% coordinate frame is computed. srcPts and dstPts need to have the same
% dimensions, at least 3 3D points are needed.
% srcPts and dstPts must have 3 rows and between 3 and N columns.
%
% The transformation is an Euclidean one.
%
% based on M. W. Walker, L. Shao, R. A. Volz,
% Estimating 3-D location parameters using dual number quaternions,
% CVGIP: Image Understanding, vol. 54, pp. 358-367, November 1991.

function [T] = pointBasedRegistration(srcPts, dstPts)

N = size(srcPts,2);

C1 = zeros(4);
C2 = zeros(4);

for i=1:N
    x = srcPts(:,i);
    y = dstPts(:,i);
    
    C1 = C1 + [skew(y)*skew(x)+y*x' -skew(y)*x; -y'*skew(x) y'*x];
    C2 = C2 + [-skew(x)-skew(y) x-y; -(x-y)' 0];
end
C1 = -2*C1;
C2 = 2*C2;

A = 0.5*[1/(2*N)*C2'*C2-C1-C1'];

[V,D] = eig(A);

largestEigenvalue = D(1,1);
q = V(1:4,1);
for i=2:size(D,2)
    if D(i,i)>largestEigenvalue
        largestEigenvalue = D(i,i);
        q = V(1:4,i);
    end
end

R = (q(4)^2 - q(1:3)'*q(1:3))*eye(3) + 2*q(1:3)*q(1:3)' + 2*q(4)*skew(q(1:3));

s = -1/(2*N)*C2*q;

p = [q(4)*eye(3)-skew(q(1:3)) q(1:3); -q(1:3)' q(4)]' * s;

T = [R p(1:3); 0 0 0 1];

