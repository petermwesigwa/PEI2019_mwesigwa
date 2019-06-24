function varargout = plotfloatpath(float_name, points, degree, fig)
  
% function [plt quiv r2Longs, r2Lats = plotfloatpath(float_name, points, degree, fig)
%
% Description
% Reads in the data for a plot of a particular float and plots the data over a few days
%
% Inputs
% FLOAT_NAME  Name of the float whose information we want to plot
% FIG  the figure to contain the plot
% POINTS   the number of points to be used to generate the linear model for computing the trajectories
% DEGREE - the degree used for the fit of all the points
%
% Outputs - 
% PLT - plot of the data
% QUIV - the quiver plot of the data
% R2LONGS - the r2 values for the longitude velocity prediction of
% each point
% R2LATA -the r^2 values for the latitude velocity predictions for
% each point
%
%
% Last modified by Peter Mwesigwa on Jun 24 2019
  
  
  url = strcat('http://geoweb.princeton.edu/people/simons/SOM/', float_name, '_030.txt');
  data = parsemermaiddata(url);
  [longs, lats, dLongs, dLats, r2Longs, r2Lats] = predictfloatpaths(data, points, degree, fig);
  [plt, quiv] = plotpath(float_name, longs, lats, dLongs, dLats, fig);
  
  % optional output arguments
  varns={plt, quiv, r2Longs, r2Lats};
  varargout=varns(1:nargout);