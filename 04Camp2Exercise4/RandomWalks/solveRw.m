function [ probabilities mask] = solveRw( A,seeds,labels,beta)
%SOLVERW Solve random walks for probabilities with delsq approach.
%   
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation
%
%   Based on the paper:
%   Leo Grady, "Random Walks for Image Segmentation", IEEE Trans. on Pattern 
%   Analysis and Machine Intelligence, Vol. 28, No. 11, pp. 1768-1783, 
%   Nov., 2006.
%   
%   Available at: http://www.cns.bu.edu/~lgrady/grady2006random.pdf
%   Original code available at http://cns.bu.edu/~lgrady/software.html

% Index matrix with boundary padding
G = find(ones(size(A))); % vector of indices of A
G = reshape(G,size(A)); % indices in shape of A

pad = 1;

% add zeros around matrices
G = padarray(G,[pad pad]);
AP = padarray(A,[ pad pad]);

% Graph-Laplacian
L = buildLaplacian(G, AP,beta);

% Select marked columns from Laplacian to create L_M and B^T
BT = L(:,seeds);

% Select marked nodes to create BT^T
N = sum(G(:)>0);
i_U = 1:N;
i_U(seeds) = 0;
i_U = find(i_U); % Index of unmarked nodes
BT = BT(i_U,:);

% TODO  Remove marked nodes from Laplacian by deleting rows and cols
% Essentially, create Lu
L = ???;

% Adjust labels
label_adjust=min(labels); labels=labels-label_adjust+1; % labels > 0

% Find number of labels (K)
labels_record(labels)=1;
labels_present=find(labels_record);
number_labels=length(labels_present);

% TODO-Define M matirx
M= ???

% TODO- Define right-handside of random walks
rhs = sparse(???);

% TODO - Solve system of linear equations
% Hint: At this point all the matrices you need have been defined

% Prepare output
probabilities = zeros(N,number_labels);
for k=1:number_labels
    % Probabilities for unmarked nodes
    probabilities(i_U,k)=x(:,k);
    % Max probability for marked node of each label
    probabilities(seeds(labels==k),k) = 1.0;
end

[dummy mask]=max(probabilities,[],2);
%Assign original labels to mask
mask=labels_present(mask)+label_adjust-1;
% reshape indices to image
mask=reshape(mask,size(A));

% Final reshape with same size as input image (no padding)
probabilities=reshape(probabilities,[size(A,1) size(A,2) number_labels]); 


end