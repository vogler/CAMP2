%   Level-Set Segmentation with Chan-Vese model - Exercise
%   
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation
%
%   Based on the paper:
%   Chan, T.F. and Sandberg, B.Y. and Vese, L.A., "Active contours without edges for vector-valued images",
%	Journal of Visual Communication and Image Representation,
%	11,2,130-141,2000


clear; clc; close all;

% Load image
I = im2double(imread('CTAbdomen.png'));

% Subsample, just to speed up computation for our exercise
I = I(1:2:end,1:2:end);

% Draw initial contour or use a prepared one from a file
isManualInit = true;
if(isManualInit)
    R = roipoly(I);
else
    load('ManualInit.mat');
end

% Define level-set function
phi = phiFunc(R,1);
% Show image
figure(1); imagesc(I,[-0.5 1.5]); axis image; colormap gray; axis off;
% hold figure to continue drawing the propagating contour
hold on;
% Show contour
contour(phi, [0 0], 'r','LineWidth', 2);

% Number of iterations - used as stopping criterium
iter = 1000;

% User parameters for controlling evolution
kappa = 0.5;
lambda = 0.01;   

for p = 1:iter
   	% Dirac of phi function (see heaviside for details)
    dirac_phi = heaviside(phi,1,1.5);
    
     % Image energy terms
    % 1) Variation of intensities inside contour
    %TODO
    mu_i = mean(I(phi<0)); % Mean von allen Punkte innerhalb der Kontour
    % 2) Variation of intensities outside contour    
    %TODO
    mu_o = mean(I(phi>0));  % Mean von allen Punkte auﬂerhalb
    
   
    % Contour curvature term
    [grad1 grad2]=grad(phi);    
    cont=lambda*div(grad1, grad2); %Contour feste Formel Folie 17
    % Update function
   
    phi = phi- kappa*dirac_phi.*(-(I-mu_i).^2+(I-mu_o).^2)+cont; % neues Phi siehe Folie Seite 20
    % Show propagation of contour
    if mod(p,1)==0
        figure(1); imagesc(I,[-0.5 1.5]); axis image; colormap gray; axis off;
        title(['Step :' num2str(p)]);
        hold on;
        contour(phi,[0 0],'r','LineWidth',2);
        hold off; drawnow        
    end
end






