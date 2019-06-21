function [m] = derivative(coeffs, x)
% function [m] = getTangent(coeffs)
% 
% Description:
% computes the gradien
%
% Inputs
% COEFFS: the coefficients for the polynomial
% 
% Outputs
% M: the gradient of the tangent
%
% Last modified by mwesigwa@princeton.edu Jun 21 2019
% 

n = length(coeffs);
m = 0;
for i = 1:n-1
    m = m + (n-i) * coeffs(i) * x^(n-1-i);
end