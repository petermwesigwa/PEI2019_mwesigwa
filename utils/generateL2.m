function varargout = generateL2(x_vals, y_vals, degree, xver)
% function [coeffs] = generateL2(x_vals, y_vals, degree, xver)
% 
% Description
% This function computes the line of best fit between an array of
% independent and dependent variables
%  
% Inputs
% X_VALS : The array of independent variables
% Y_VALS : The array of dependent variables
% DEGREE : The degree of polynomial for the fit
% xver     1 extra verification
%          0 don't
%
% Outputs
% COEFFS Coefficients of the polynomial of best fit ax^n + bx^(n-1) 
%  + ... + k returned as an array [a, b, ..., k]
%
% Example usage
% coeffs = generateL2(1:4, 2:5, 1)
%  returns [1 1]
%
%
% Last modified by mwesigwa@princeton.edu Jun 25 2019
%

% number of x-values
n = length(x_vals);

% create the X matrix
x = str2double(cell(n, degree+1)); 
for j=1:degree+1
  for i=1:n
    x(i,j) = x_vals(i).^(degree-j+1);
  end
end

% Compute the linear fit for all these points
defval('meth',2)
switch meth

  % This case generates the inverse using right divide
  case 1
    % transpose the x matrix
    xT = transpose(x);
    
    % compute the coefficients of regression
    xTx = xT*x;
    xTy = xT*y_vals;
    coeffs = xTx\xTy;
   
  case 2 % this case uses the pinv function
    coeffs = pinv(x)*y_vals;
end

% extra functionality for debugging
defval('xver', 0)
if xver==1
  x
  coeffs
  plot(x_vals, y_vals, 'kx')
  hold on;
  plot(x_vals, evalpol(coeffs, x_vals))
  hold off;
end

% return optional arguments
varns={coeffs};
varargout=varns(1:nargout);