function showacc(thr)
% function varargout = showacc(thr)
%
% Displays variation of accuracy of MERMPRED with increase in future time
% for which prediction is made
% 
% --------------------------------
% Inputs: 
%
% THR Threshold distance, all accurate predictions must have the actual
% point lying within this distance of the prediction. Default value of 
% 15 km
%
% --------------------------------
% Outputs:
% None
% 
% Last modified by mwesigwa@princeton.edu Jul 19 2019
%

% set default value
defval('thr', 15)

% get the accuracy values 
acc = testpreds(thr, 11);

% plot 
bar(acc(1,:), acc(2,:), 0.1)
ti = sprintf('Accuracy  with threshold  of %d km made on %s', thr, date());
title(ti)
xlabel('Future distance in days of prediction')
ylab = sprintf('Fraction of floats within %d km of predicted location', thr);
ylabel(ylab)
ylim([0 1])
