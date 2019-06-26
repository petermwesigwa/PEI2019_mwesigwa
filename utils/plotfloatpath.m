function varargout = plotfloatpath(float_name, points, degree, fig)  
% function [plt quiv meanErrLongs meanErrLats
% sdErrLongs sdErrLats r2Longs r2Lats] = plotfloatpath(float_name, points, degree, fig)
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
% POINTS   the number of points to be used to generate the linear
% model for computing the trajectories. Default number is 7
% DEGREE  the degree used for the fit of all the points. Default
% number is 2
%
% Outputs 
% PLT  plot of the data
% QUIV  the quiver plot of the data
% R2LONGS  the r2 values for the longitude velocity prediction of
% each point
% R2LATS the r^2 values for the latitude velocity predictions for
% each point
%
% Example Usage
% [plt] = plotfloatpath('P018, 7, 2, fig)
%
% Last modified by mwesigwa@princeton.edu Jun 25 2019
%
% 

% default values for the parameters
defval('float_name', 'P020');
defval('points', 7);
defval('degree', 2);

% construct the url with the data for this particular float
url = strcat('http://geoweb.princeton.edu/people/simons/SOM/', float_name, '_030.txt');

% read and store the data from the url in a cell array
data = parsemermaiddata(url);

% make predictions for each data point in the data
[longs, lats, dLongs, dLats, stats] = predictfloatpaths(data, ...
                                                  points, degree);

% plot the data points as well as the predictions
[plt, quiv] = plotpath(float_name, longs, lats, dLongs, dLats, fig);

% optional output arguments
varns={plt, quiv, stats};
varargout=varns(1:nargout);