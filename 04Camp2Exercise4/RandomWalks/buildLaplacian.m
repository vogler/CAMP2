function L = buildLaplacian( G, A, beta )
%BUILDLAPLACIAN DELSQ Implementation of Random Walks
%   Author: Athanasios Karamalis
%   Date: 08.05.2012
%   CAMP II - Advanced Image Segmentation
%
% L:    Weighted Graph Lacplacian
% G:    Indexing matrix
% A:    Matrix/Image

[m,n] = size(G);

% Indices of interior points
p = find(G);

% Connect interior points to themselves with 4's.
i = G(p); % Index vector
j = G(p); % Index vector
s = zeros(size(p)); % Entries vector, initially for diagonal

% for k = N,S
for k = [-1 1]
   % Possible neighbors in k-th direction
   Q = G(p+k);
   % Index of points with interior neighbors
   q = find(Q); 
   % Connect interior points to neighbors with -1's.
   ii = G(p(q));
   i = [i; ii]; % Interior points
   jj = Q(q);
   j = [j; jj]; % Neighbors   
   W = abs(A(p(ii))-A(p(jj)));   
   s = [s; W];   
end

% for k = east and west
for k = [m -m]
   % Possible neighbors in k-th direction
   Q = G(p+k);
   % Index of points with interior neighbors
   q = find(Q); 
   % Connect interior points to neighbors with -1's.
   ii = G(p(q));
   i = [i; ii]; % Interior points
   jj = Q(q);
   j = [j; jj]; % Neighbors   
   W = abs(A(p(ii))-A(p(jj)));
   s = [s; W];
end

% Normalize weights
s = (s - min(s(:))) ./ (max(s(:)) - min(s(:)) + eps);

% Gaussian weighting
EPSILON = 10e-6;
s = -((exp(-beta*s)) + EPSILON);

% Create Laplacian, diagonal missing
L = sparse(i,j,s); % i,j indices, s entry (non-zero) vector

% Reset diagonal weights to zero for summing 
% up the weighted edge degree in the next step
L = spdiags(zeros(size(s,1),1),0,L);
% Weighted edge degree
D = full(abs(sum(L,1)))';

% Finalize Laplacian by completing the diagonal
L = spdiags(D,0,L);

end

