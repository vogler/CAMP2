% ART - Algebraic Reconstruction Technique
function x = art(A, b, iterations, lambda)

tic;

% set parameters
dim = sqrt( size(A, 2) )
cols = size(A, 2)
rows = size(A, 1)

if nargin < 4
    lambda = 1;
end;

% initialize algorithm
% x = zeros(cols,iterations);
x = zeros(cols,1);

for iter = 1:iterations

    for row = 1:rows

        % perform iteration
         Ai = A(row,:);
         factor = lambda * ((b(row)-Ai*x)/sum(abs(Ai * Ai')));
         x = x + factor * Ai';
        
    end

end;

x = reshape(x, dim, dim);

elapsed = toc;
disp(['ART done in ' num2str(elapsed) ' seconds.']);

