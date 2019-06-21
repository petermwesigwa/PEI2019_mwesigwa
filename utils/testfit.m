function [r_squared] = testfit(x_vals, y_vals, fit)
% function [r_squared] = testFit(x_vals, y_vals, fit)
%
% Tests polynomial fit on the values given and returns the expected fit for
% the data
%
% Inputs
% X_VALS:  x-values of the test set
% Y_VALS:  y-values of the test set
% FIT:  the coefficients of the polynomial fit. if the fit is y = ax^n +
% bx^(n-1) + ... + k, this is the vector [a b ... k]
%
% Last modified by mwesigwa@princeton.edu Jun 21 2019
%

f = zeros(size(y_vals));

degree = length(fit);
for i=1:degree
   f = f + fit(i) * x_vals.^(degree-i);
end

errors = y_vals - f;
sse = errors'*errors;

mean = y_vals/length(y_vals);
sd = y_vals - mean;
ssd = sd'*sd;

r_squared = 1 - sse/ssd;

