
load('two-moons.mat');
% test_classification_forests(xtrain, ytrain, xtest, ytest, 10, 3:2:15); %
% just executes for 3:2:15??

treeDepths = 3:2:15;
errorRates = [];
for treeDepth=treeDepths
   [predTest, errorTest] = test_classification_forests(xtrain, ytrain, xtest, ytest, 10, treeDepth);
   errorRates(end+1) = errorTest;
end
close all;
figure; clf; hold on; plot(treeDepths, errorRates);
title('error rate vs. tree depth');
xlabel('tree depth');
ylabel('error rate');