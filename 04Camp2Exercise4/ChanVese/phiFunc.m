function [ phi ] = phiFunc( R, type )
%PHI Compute level set function from binary mask
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation

% Signed distance transform
if(type==0)
    %TODO
    %inv = -1*(1-R);
    %phi1 = bwdist(R); % outside
    %phi2 = bwdist(inv); % inside
    %phi = R .* (-1 * phi2) + inv .* phi1;
    phi_in = bwdist(~R)-1; % contour should be zero
    phi_in(phi_in < 0) = 0; % set outside to zero
    phi_out = bwdist(R);
    phi = phi_out - phi_in;
% Narrow-band
elseif(type==1)
    bd = 4;
    phi = bd*(0.5-R);
    phi = imfilter(phi,ones(5)/25,'symmetric');
end

end

