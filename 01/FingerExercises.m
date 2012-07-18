%Here are a few MATLAB finger exercises:

%clear all variables
clear all

%close all windows
close all

%clear the command windows
clc

%generate a random matrix of size 5x6
A = rand(5, 6)

%delete the last column of A
A = A(:, 1:length(A)-1)

%transform A into a vector
A = A(:)

%transform v back into a matrix
A = reshape(A, 5, 6)

%get the biggest entry of A row 1
max(A(1, :))

%get the biggest entry of A col 2
max(A(:, 2))

%treat A as an image and visualize it
imshow(A)

%create another matrix B and multiply it with A
B = rand(6, 5)
B = a*B

%multiply every entry of A with the corresponding entry of B
%the dot indicates that the operation * shall be performed componentwise 
B = rand(5, 6)
a.*B

%square every entry of B
B = B .* B

%create a third matrix C filled with zeros
C = zeros(5, 6)

%write the difference of the last two rows of A and B into the last
%two rows of C (note that for + and - no dot is necessary!) 
C(size(C)-1:size(C), :) = (A-B)(4:5, :)


