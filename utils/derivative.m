function [m] = derivative(coeffs, x)
% function [m] = derivative(coeffs)
% 
% Description:
% computes the gradient of a polynomial at a given point
%
% Inputs
% COEFFS: the coefficients for the polynomial ax^n + bx^(n-1) +
% ... + k as a vector [a, b,..., k
% 
% Outputs
% M: the gradient of the tangent
%
% Last modified by mwesigwa@princeton.edu Jun 25 2019
% 

n = length(coeffs);
m = 0;

for i = 1:n-1
  % differentiate each term of polynomial and add it to gradient
    m = m + (n-i) * coeffs(i) * x^(n-1-i);
end