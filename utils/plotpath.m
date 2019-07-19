function varargout = plotpath(float_name, longs, lats, dLongs, dLats)
% function [plt quiv] = plotpath(float_name. longs, lats, dLongs,
% dlats, fig)
% 
% Description:
% Given the float path, this
%
% Inputs
% FLOATNAME  name of the float
% LONGS   Vectors of longitudes as returned by PREDICTFLOATPATHS
% LATS  Vector of latitudes as returned by PREDICTFLOATPATHS
% DLONGS  Vector of longitudes as returned by PREDICTFLOATPATHS
% DLATS Vector of latitudes
% FIG figure to contain the plots (if any)
% 
% Output
% PLT  plot containing the points
% QUIV  Quiver plot containing the points
%
% Last modified by mwesigwa@princeton.edu Jun 25 2019
% 



% plot a graph of latitude against longitude for each observation
plt = plot(longs, lats, 'rx');

% add vectors to show the velocities of each point
hold on;
quiv = quiver(longs, lats, dLongs, dLats, 'AutoScale',' on', 'AutoScaleFactor', 0.5);
hold off;

% decorate the graph
title(strcat('Mermaid locations over 30 days with expected trajectories for', ' ', float_name));
ylabel('Latitude');
xlabel('Longitude');
%text(longs, lats, labels)

% optional output
varns = {plt quiv};
varargout = varns(1:nargout);