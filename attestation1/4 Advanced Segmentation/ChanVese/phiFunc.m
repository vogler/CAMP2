function [ phi ] = phiFunc( R, type ) % R is binary (1 = region, 0 = background)
%PHI Compute level set function from binary mask
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation

% Signed distance transform
if(type==0)
    % phi: <0 inside region, 0 on contour, >0 outside
    % bwdist: distance to next non-zero pixel
    phi_in=bwdist(~R)-1; % inside-1
    phi_in(phi_in<0)=0;  % set contour to zero
    phi_out=bwdist(R);   % outside
    phi=phi_out-phi_in;
% Narrow-band
elseif(type==1)
    bd = 4;
    phi = bd*(0.5-R); % inside -2, outside 2 
    phi = imfilter(phi, ones(5)/25, 'symmetric'); % average filter
end

end

