function [coeffs] = generateL2(x_vals, y_vals, degree)
% function [m, c] = l2_model(x_vals, y_vals, degree)
% 
% Description
% This function computes the line of best fit between an array of
% independent and dependent variables
%  
% Inputs
% X_VALS : The array of independent variables
% Y_VALS : The array of dependent variables
% DEGREE : The degree of polynomial for the fit
%
% Outputs
% M : Gradient of line of best fit
% C : Y-intercept of line of best fit
% 
% Last modified by mwesigwa@princeton.edu Jun 21 2019
%
    n = length(x_vals);
    
    x = str2double(cell(n, degree+1));
    for j=1:degree+1
        for i=1:n
            x(i,j) = x_vals(i).^(degree-j+1);
        end
    end
    
    xT = transpose(x);
    y = y_vals;

    % Compute the linear fit for all these points
    xTx = xT*x;
    xTy = xT*y;
    coeffs = xTx\xTy;
    
