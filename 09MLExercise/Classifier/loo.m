%function [ precision, recall, fmeasure, errorRate ] = loo( input, method, filzer_size )
%LOO Summary of this function goes here
%   Detailed explanation goes here
if(nargin==0)
    input = '../Datasets/*.mat';
    method = 'mean'; % mean or binary
    filter_size = 3;
    nTrees = 10;
    treeDepth = 15;
    positiveLabel = 2;
end    
% measures = {};
measures = [];
files = dir(input);
n = length(files);
ratio = 0.8; % 1/n
% k is the validation set
for k=1:n
    xtrain = []; ytrain = [];
    xtest = []; ytest = [];
    MR = []; GT = []; % will be loaded
    % go through all datasets
    for i=1:n
        file = files(i).name;
        load(file); % yields MR and GT
        if strcmp(method, 'mean')
            X = featuresMean(MR, filter_size);
        else % binary
            X = featuresBinary(MR, filter_size);
        end
        y = double(GT(:));
        if i==k % the validation set
           xtest = X;
           ytest = y;
           imgsize = size(MR);
           MRtest = MR;
           GTtest = GT;
        else % part of training set
%             ratio = 1/n; % why not n-1?
%             if i==n % check if we have enough elements at the end
%                 rest = size(ytest,1)-size(ytrain,1); % (ytest has already been initialized)
%                 % ratio has to be rest/size(ytest,1)
%                 ratio = rest/size(ytest,1);
%             end
            [Xb, yb] = bootstrap(X, y, ratio); % take ratio of the set
            xtrain = [xtrain; Xb];
            ytrain = [ytrain; double(yb)];
        end
    end
    nclasses = max(ytrain(:))-min(ytrain(:))+1; % here 3
    [predTest, errorTest] = test_classification_forests(xtrain, ytrain, xtest, ytest, nTrees, treeDepth, nclasses);
%     close all;
    close; close;
    imgPred = reshape(predTest, imgsize(1), imgsize(2));
    imwrite(mat2gray(imgPred), ['../Results/' method '_' num2str(filter_size) '/' num2str(k) '.jpg'], 'jpg');
%     figure; imagesc(imgPred);
%     figure; imagesc(imgGT);
    [mp, mr, mf] = confusion(predTest, ytest, positiveLabel);
    measures(end+1, :) = [mp, mr, mf, errorTest];
end
measures
[ precision, recall, fmeasure, errorRate ] = mean(measures, 1);
%vars = evalin('base','who');