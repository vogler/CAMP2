function [quat]=DCM2Quat(dcm)
%  [quat] = DCM2Quat(C) gives a quaternion equivalent to a direction cosine matrix C
%  [quat] = Quaternion [w x y z]'
%       C = Direction Cosine Matrix (DCM) (Rows = rotated unit vectors)
% A quaternion is a 4-vector [w x y z]', where w is the scalar part and
% [x y z]' is the vector part
% A direction cosine matrix is a 3x3 rotation matrix

quat = zeros(4,1);
q = zeros(4,1);
qoff = zeros(6,1);
c = 1;

q(1) = (1 + dcm(1) + dcm(5) + dcm(9)) / 4;
q(2) = (1 + dcm(1) - dcm(5) - dcm(9)) / 4;
if (q(c) < q(2))
    c = 2;
end
q(3) = (1 - dcm(1) + dcm(5) - dcm(9)) / 4;
if (q(c) < q(3))
    c = 3;
end
q(4) = (1 - dcm(1) - dcm(5) + dcm(9)) / 4;
if (q(c) < q(4))
    c = 4;
end


qoff(1) = (dcm(6) - dcm(8)) / 4;
qoff(2) = (dcm(7) - dcm(3)) / 4;
qoff(3) = (dcm(2) - dcm(4)) / 4;
qoff(4) = (dcm(2) + dcm(4)) / 4;
qoff(5) = (dcm(3) + dcm(7)) / 4;
qoff(6) = (dcm(8) + dcm(6)) / 4;

if (c==1)
    quat(1) = sqrt(q(c));
    quat(2) = qoff(1) / quat(1);
    quat(3) = qoff(2) / quat(1);
    quat(4) = qoff(3) / quat(1);
elseif (c==2)
    quat(2) = sqrt(q(c));
    quat(1) = qoff(1) / quat(2);
    quat(3) = qoff(4) / quat(2);
    quat(4) = qoff(5) / quat(2);
elseif (c==3)
    quat(3) = sqrt(q(c));
    quat(1) = qoff(2) / quat(3);
    quat(2) = qoff(4) / quat(3);
    quat(4) = qoff(6) / quat(3);
elseif (c==4)
    quat(4) = sqrt(q(c));
    quat(1) = qoff(3) / quat(4);
    quat(2) = qoff(5) / quat(4);
    quat(3) = qoff(6) / quat(4);
end

% ensure w to be positive
if (quat(1) < 0.0)
    quat(2) = -quat(2);
    quat(3) = -quat(3);
    quat(4) = -quat(4);
    quat(1) = -quat(1);
end