function varargout = testfit(x_vals, y_vals, fit)
% function [r_squared mean_err s_err] = testfit(x_vals, y_vals, fit)
%
% Tests a fit on a given set of x and y values to see how well it
% fits the data
%
% Inputs
% XVALS  x-values of the test set
% YVALS  y-values of the test set
% FIT   the coefficients of the polynomial fit. If the fit is y = ax^n +
% bx^(n-1) + ... + k, this is the vector [a b ... k]
%
% Outputs:
% RSQUARED  the r squared coefficient of determination between the
% independent and dependent variable. This is a fraction stating
% the fraction of the variance in the dependent variable can be
% explained by that of the independent variable. 
% ERRORS the difference between the predicted y-value and the
% observed y-value for each observation in the training set
%
% Last modified by mwesigwa@princeton.edu Jul 17 2019
%

% y predictions based on the fit
y_preds = zeros(size(y_vals));

% degree of polynomial used for the fit
degree = length(fit);

% get y predictions
for i=1:degree
   y_preds = y_preds + fit(i) * x_vals.^(degree-i);
end

% compute the residual sum of squares
errors = y_vals - y_preds;
sse = errors'*errors;

% compute the total sum of squares
me = y_vals/length(y_vals);
sd = y_vals - me;
ssd = sd'*sd;

r_squared = 1 - sse/ssd;

% optional arguments
varns={errors};
varargout=varns(1:nargout);
