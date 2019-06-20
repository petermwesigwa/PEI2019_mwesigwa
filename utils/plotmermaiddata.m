function [plt quiv] = plotfloatpath(float_name, points, fig)

  % function [plt quiv] = plotfloatpath(float_name, points, fig)
%
% Description
% Reads in the data for a plot of a particular float and plots the data over a few days
%
% Inputs
% FLOAT_NAME - Name of the float whose information we want to plot
% FIG - the figure to contain the plot
% POINTs - the number of points to be used to generate the linear model for computing the trajectories
%
% Outputs - 
% plt - plot of the data
% quiv - the quiver plot of the data
%
% Last modified by Peter Mwesigwa on Jun 19 2019

  url = strcat('http://geoweb.princeton.edu/people/simons/SOM/', float_name, '_030.txt')
  data = parsemermaiddata(url);
[plt quiv] = plottrajectory(data, points, fig);
