function [coeffs] = generateL2(x_vals, y_vals, degree,xver)
% function [m, c] = l2_model(x_vals, y_vals, degree,xver)
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
% M : Gradient of line of best fit
% C : Y-intercept of line of best fit
% 
% Last modified by mwesigwa@princeton.edu Jun 21 2019

n = length(x_vals);

x = str2double(cell(n, degree+1));
for j=1:degree+1
  for i=1:n
    x(i,j) = x_vals(i).^(degree-j+1);
  end
end

% Make a plot
defval('xver',1)
if xver==1
  plot(x_vals,y_vals,'+')
end

xT = transpose(x);
y = y_vals;

% Compute the linear fit for all these points
defval('meth',1)
switch meth
  case 1 
    xTx = xT*x;
    xTy = xT*y;
    coeffs = xTx\xTy;
  case 2
    coeffs = pinv(x)*y;
  case 3
end

