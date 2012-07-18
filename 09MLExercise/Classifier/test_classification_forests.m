% AUTHOR: Olivier Pauly
% EMAIL: pauly@cs.tum.edu

function [predTest, errorTest] = test_classification_forests(xs0, ys0, xs1, ys1, NbTree,TreeDepth, Nbclasses)

if(nargin==0)
    NbTree = 10;
    TreeDepth = 5;

    % first create dummy data
    N=1000;
    
    % training set, first class
    xs0=[randn(5*N,2); 4+randn(N,2)];
    ys0=[ones(5*N,1); 2.*ones(N,1)];
    
    % test set
    xs1=[randn(5*N,2); 4+randn(N,2)];
    ys1=[ones(5*N,1); 2.*ones(N,1)];
end
if(nargin<=6)
   Nbclasses = 2; 
end

%% create forest structure
disp('creating structure...')
Ntry = 10;
% Nbclasses = 2;
Dim = 2;

obj = ClassificationRandomForests(Dim, Nbclasses, NbTree, TreeDepth, Ntry);

%% perform regression on training set
disp('performing regression...')
tic
obj = performTraining(obj,xs0,ys0);
toc

%% perform predictions on both training and test sets
disp('performing predictions on train and test set...')
tic
Y = computePredictions(obj,xs0);
[~, pred_train] = max(Y,[],2);
toc
tic
Y = computePredictions(obj,xs1);
[~, pred_test] = max(Y,[],2);
toc

%% compute train and test errors
error_train = sum(ys0~=pred_train)/numel(ys0);
error_test = sum(ys1~=pred_test)/numel(ys0);
fprintf('errors train=%f test=%f\n',error_train,error_test);

%% visualize results
figure; clf; hold on; scatter(xs0(ys0==1,1),xs0(ys0==1,2),'.b'); scatter(xs0(ys0==2,1),xs0(ys0==2,2),'.r'); scatter(xs0(pred_train==1,1),xs0(pred_train==1,2),'bo'); scatter(xs0(pred_train==2,1),xs0(pred_train==2,2),'ro');
figure; clf; hold on; scatter(xs1(ys1==1,1),xs1(ys1==1,2),'.b'); scatter(xs1(ys1==2,1),xs1(ys1==2,2),'.r'); scatter(xs1(pred_test==1,1),xs1(pred_test==1,2),'bo'); scatter(xs1(pred_test==2,1),xs1(pred_test==2,2),'ro');

%% return values
predTest = pred_test;
errorTest = error_test;