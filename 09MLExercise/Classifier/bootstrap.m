function [ X, y ] = bootstrap( Xin, yin, ratio )
%BOOTSTRAP Summary of this function goes here
%   Detailed explanation goes here
    n = numel(yin);
    s = floor(ratio*n);
    i = randi(n, s, 1); % vector of size s x 1, containing uniform random numbers from 1:n
    X = Xin(i, :);
    y = yin(i, :);
end