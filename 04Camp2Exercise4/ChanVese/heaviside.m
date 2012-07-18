function heaviside_x = heaviside(x,type,epsilon)
% HEAVISIDE Analytic approximations for Heaviside and Dirac delta functions
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation

if type==0 % Heaviside approx.
    heaviside_x = (x > epsilon)+(abs(x) <= epsilon).*(1 + x/epsilon + 1/pi*sin(pi*x/epsilon))/2;
else % Dirac approx.
    heaviside_x = (abs(x) <= epsilon).*(1 + cos(pi*x/epsilon))/(2*epsilon);
end