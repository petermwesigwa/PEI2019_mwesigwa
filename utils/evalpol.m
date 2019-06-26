function y = evalpol(coeffs, x)
% function y = evalpol(coeffs, x)
%
% Description:
% Evaluates the value of a polynomial for a given value of x
% 
% Inputs:
% COEFFS The array of the  coefficient of the terms of the
% polynomial, where ax^n + bx^(n-1) + ... + k is represented 
% by the array [a b ... k]
%
% X The x value whose y value is being computed
%
% Outputs
% Y The y value of the polynomial at the given x co-ordinate
%
% Usage
% y = evalpol([1 2 3], 1) evaluates f(x) = x^2 + 2x + 3 at x = 1
%
% Last modified by mwesigwa@princeton.edu Jun 26 2019
%


% initialize values 
y = 0

% degree of polynomial
degree = length(coeffs);


for i=1:degree
   y = y + coeffs(i) * x ^ (degree - i)
end
