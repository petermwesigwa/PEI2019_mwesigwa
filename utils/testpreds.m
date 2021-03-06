function varargout = testpreds(thr, test, pt, ploterrors)

% function varargout = testpreds(thr, test, pt, ploterrors);
% --------------------------
% Tests the predictions made by MERMPRED and returns statistics about their
% accuracy. Filters the mermaid data and picks one observation for each
% day, therefore observations are approximately 6-8 days apart.
%
% --------------------------
% Inputs:
%
% THR maximum error that we allow in the distance between prediction made 
% using and MERMPRED and the actual location reported
%
% PT specifying different integer values for this allows you to measure
% accuracy for just a specific row across all floats. Caution must be used
% when choosing values greater than 10 as there might not be enough data
% and errors might be thrown. When given a value less than or equal to zero,
% the accuracy is based off of the means of the errors for a number of
% rows of data. Values less than or equal to zero result in default
%
% TEST size of the test set for measuring accuracy. Each point in the test
% set is
%
% PLOTERRORS 0 for no plots, 1 for graphical representation of error
% variation with time
%
% ----------------------------
% Outputs:
%
% ACCURACY This returns the accuracies of prediction. Returns a two row
% matrix where the top row is an average of the number of days out for
% which the prediction was tested and the bottom row is the fraction of 
% all the floats which were within the THR distance of their predicted 
% location.
%
% ERRORS The errors used to compute the mean in the accuracy matrix
%
% Last modified by mwesigwa.princeton.edu Jul 18 2019
%

% default values
defval('thr', 10000)
defval('train', 5);
defval('test', 5);
defval('ploterrors',1);
defval('pt', -1)

% data detailing the current position of the floats 
current_data = parsemermaiddata("All");

% names of the floats
float_names = char(current_data(:,1));

% degree of the linear model
deg = 2;

% number of floats for which we are testing
n = length(float_names);

% times in days for which the predictions are tested
times = NaN(test, n);

% errors for these times
errors = NaN(test, n);


for i=1:n
    
    % Get the errors
    err = mermpred(float_names(i,:), ...
        test, train, deg, pt);
    times(:,i) = err(1,:);
    errors(:,i) = err(2,:);
end

if ploterrors==1
    plot(times, errors, 'r*-.', ...
    'LineWidth', 0.9);
    ti=sprintf("Errors for predictions made on %s", date());
    title(ti);
    xlabel("Prediction distance (days)")
    ylabel("Error (km)")
    text(times(test,:)+0.5, errors(test,:)+0.5, float_names);
end



% compute the accuracy
errors = transpose(errors);
times = transpose(times);

%err_flat = reshape(errors',1,[]);
%time_flat = reshape(times',1,[]);
accuracy = [nanmean(times); mean(errors <= thr)];
%accuracy = [time_flat; err_flat];

%optional output
varns={accuracy, errors};
varargout = varns(1:nargout);


