function [Dxx,Dxy,Dyy] = Hessian2D(I, sigma)

% generates 2D-grid from -5*sigma to 5*sigma
[x,y]   = ndgrid(round(-3*sigma):round(3*sigma));

% 2 times gaussian derivative
Dxxg = 1/(2*pi*sigma^4)*(x.^2/sigma^2 - 1).*exp(-(x.^2 +y.^2)/(2*sigma^2));
Dxyg = 1/(2*pi*sigma^6)*(x.*y).*exp(-(x.^2 +y.^2)/(2*sigma^2));
Dyyg = 1/(2*pi*sigma^4)*(y.^2/sigma^2 - 1).*exp(-(x.^2 +y.^2)/(2*sigma^2));


Dxx = imfilter(I,Dxxg,'conv');
Dxy = imfilter(I,Dxyg,'conv');
Dyy = imfilter(I,Dyyg,'conv');

end

