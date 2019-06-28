function varargout = plotfloatpath(float_name, trainSize, testSize, ...
                                   degree, fig, plotornot, xver)  
% function [plt quiv meanErrLongs meanErrLats
% sdErrLongs sdErrLats r2Longs r2Lats] = 
% plotfloatpath(float_name, trainSize, testSize, degree, fig, xver)
%
% Description
% Displays the reported locations of a mermaid float over the past
% 30 days. Uses this data to formulate, display, and test a prediction
% algorithm to predetermine the mermaid's position in longitude and
% latitude at a certain time. 
%
% Inputs
% FLOATNAME  Name of the float whose information we want to plot
% FIG  the figure to contain the plot (if any)
% TRAINSIZE  the size of the training set for developing the model. Default
% is 7
% TESTSIZE  size of the test set for testing the model's accuracy
% DEGREE  the degree used for the fit of all the points. Default
% number is 2
% PLOTORNOT plot the points and trajectories if 1, otherwise not
% XVER extra verification, runs additional tests if 1, otherwise not
%
% Outputs 
% PLT  plot of the data
% QUIV  the quiver plot of the data
% STATS A 6 column matrix detailing stats measuring the accuracy of
% the model. The columns are coefficient of determination, mean
% error, standard deviation of error, and error scaling factor with
% time for longitudes and latitudes respectively 
% |      r^2      |     mean     |    stddev    | error factor |
% | longs | lats  | longs | lats | longs | lats | longs | lats |
%
%
% Example Usage
% plt = plotfloatpath('P018, 7, 2, fig)
% Returns the plot handle for the graph plotted. Add extra
% parameters to get the quiver plot as well as stats detailing the
% accuracy of the plot
%
% Last modified by mwesigwa@princeton.edu Jun 27 2019
%
% 

% default values for the parameters
defval('float_name', 'P020');
defval('trainSize', 7);
defval('testSize', 10);
defval('degree', 2);
defval('xver', 0);

% construct the url with the data for this particular float
url = strcat('http://geoweb.princeton.edu/people/simons/SOM/', float_name, '_030.txt');

% read and store the data from the url in a cell array
data = parsemermaiddata(url);

% make predictions for each data point in the data
[longs, lats, dLongs, dLats, fitLongs, fitLats, stats] = predictfloatpaths(data, ...
                                                  trainSize, testSize, ...
                                                  degree, xver);
dLongs
dLats
% plot the data points as well as the predictions
[plt, quiv] = plotpath(float_name, longs, lats, dLongs, dLats, fig);

% optional output arguments
varns={plt, quiv, stats};
varargout=varns(1:nargout);