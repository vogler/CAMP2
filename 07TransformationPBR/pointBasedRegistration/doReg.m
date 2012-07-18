%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test script for Iterative Closest Point Registration
% The script initializes the transformation using
% mean displacements as translation and the principal
% components as rotation matrices
% Then the ICP is called.
%
% based on the version implemented by Martin Groher, TUM, 2006
% For the course 
% COMPUTER AIDED MEDICAL PROCEDURES (CAMP) II
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
load X.mat;
load -ascii PhantomPointsLeft.mat;
PhantomPointsLeft = PhantomPointsLeft';
load -ascii PhantomPointsRight.mat;
PhantomPointsRight = PhantomPointsRight';
Y = [PhantomPointsLeft, PhantomPointsRight];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% find initial transformation via mean and Principal Component Analysis:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (1) calculate the mean of X and save result in Xmean:
% TODO
Xmean = mean(X,2);

% (2) demean X and save result in Xtilde:
% TODO
Xtilde = X-repmat(Xmean, 1, size(X,2));

% (3) demean Y and save result in Ytilde:
% TODO
Ymean = mean(Y,2);
Ytilde = Y-repmat(Ymean, 1, size(Y,2));

% (4) compute covariance matrix of X,Y and get principal components:
% call princ. comp. of X Rx 
% and princ. comp. of Y Ry
% TODO
% Cov = cov(X,Y);
[Rx Sx Vx] = svd(Xtilde*Xtilde');
[Ry Sy Vy] = svd(Ytilde*Ytilde');

% transform:
t = Xmean;
tArray = [ones(1,size(Y,2)) .* t(1);
          ones(1,size(Y,2)) .* t(2);
          ones(1,size(Y,2)) .* t(3)];
Ry(:,2:3) = -Ry(:,2:3); % due to ambigous ellipsoid of PCA
Yn = Rx*Ry'*Ytilde;
Yn = Yn + tArray;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % do ICP:
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reduce sizes:
Yn_icp = Yn(:, 1:60:size(Yn,2));
X_icp = X(:,1:40:size(X,2));
disp('starting ICP...');
%icp:
[R,t,iters] = IterativeClosestPoint(Yn_icp, X_icp, 5); %50
disp('ICP terminated.');
tArray = [ones(1,size(Yn,2)) .* t(1);
          ones(1,size(Yn,2)) .* t(2);
          ones(1,size(Yn,2)) .* t(3)];
Yicp = R*Yn + tArray;
%overall transformation (initialization and ICP):
Ticp = [R*Rx*Ry'        R*(Xmean - Rx*Ry'*Ymean) + t
        0   0   0                  1                ];
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % compute transformation using point based registration for comparison:
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load allMarkersWorld.txt
load allMarkersCT.txt
allMarkersWorld = allMarkersWorld';
allMarkersCT = allMarkersCT';
Tpbr = pointBasedRegistration( allMarkersWorld, allMarkersCT );
Ypbr = Tpbr * [Y;ones(1,size(Y,2))];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot data:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot3(X(1,:), X(2,:), X(3,:), 'b.');
grid on;
hold on;
plot3(PhantomPointsLeft(1,:), PhantomPointsLeft(2,:), PhantomPointsLeft(3,:), 'r.');
grid on;
hold on;
plot3(PhantomPointsRight(1,:), PhantomPointsRight(2,:), PhantomPointsRight(3,:), 'g.');
plot3(Yn(1,:), Yn(2,:), Yn(3,:), 'y.');
% plot3(Yicp(1,:), Yicp(2,:), Yicp(3,:), 'c.');
% % commparison (transformation from PointBasedRegistration, Umeyama):
% plot3(Ypbr(1,:), Ypbr(2,:), Ypbr(3,:), '.m');
plot3([Xmean(1), Xmean(1)+Rx(1,1)*100],[Xmean(2), Xmean(2)+Rx(2,1)*100],[Xmean(3), Xmean(3)+Rx(3,1)*100],'k', 'LineWidth',3);
legend('CT surface', 'left lobe tracking data', 'right lobe tracking data', 'tracking data after PCA', 'tracking data after ICP', 'tracking data after Umeyama', 'coordinate axes', 'Location','NorthEastOutside');
plot3([Xmean(1), Xmean(1)+Rx(1,2)*100],[Xmean(2), Xmean(2)+Rx(2,2)*100],[Xmean(3), Xmean(3)+Rx(3,2)*100],'k', 'LineWidth',3);
plot3([Xmean(1), Xmean(1)+Rx(1,3)*100],[Xmean(2), Xmean(2)+Rx(2,3)*100],[Xmean(3), Xmean(3)+Rx(3,3)*100],'k', 'LineWidth',3);
plot3([Ymean(1), Ymean(1)+Ry(1,1)*100],[Ymean(2), Ymean(2)+Ry(2,1)*100],[Ymean(3), Ymean(3)+Ry(3,1)*100],'k', 'LineWidth',3);
plot3([Ymean(1), Ymean(1)+Ry(1,2)*100],[Ymean(2), Ymean(2)+Ry(2,2)*100],[Ymean(3), Ymean(3)+Ry(3,2)*100],'k', 'LineWidth',3);
plot3([Ymean(1), Ymean(1)+Ry(1,3)*100],[Ymean(2), Ymean(2)+Ry(2,3)*100],[Ymean(3), Ymean(3)+Ry(3,3)*100],'k', 'LineWidth',3);

