function y = evalpol(coeffs, x)
% function y = evalpol(coeffs, x)
%
% Description:
% Evaluates the value of a polynomial for given values of x
% 
% Inputs:
% COEFFS The array of the  coefficient of the terms of the
% polynomial, where ax^n + bx^(n-1) + ... + k is represented 
% by the array [a b ... k]
%
% X  This is the x-value (or vector of values) for which we need
% corresponding y value(s)
%
% Outputs
% Y The y values of the polynomial at the given x co-ordinates
%
% Usage
% y = evalpol([1 2 3], 1) evaluates f(x) = x^2 + 2x + 3 at x = 1
% y = evalpol([1 2 1], [-1 0 1]) returns [0 1 4]
%
% Last modified by mwesigwa@princeton.edu Jun 27 2019
%


% initialize y values
y = zeros(size(x));

% degree of polynomial
degree = length(coeffs);


for i=1:degree
   y = y + coeffs(i) * x.^(degree - i);
end
