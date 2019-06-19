function [lats, longs, fig] = plotlatvslong(data, plotornot)
  % function [fig] = plotlatvslong(data)
%
% Description
% This data takes in the float data parsed from the float and then plots the latitude and longitude columns
% Returns the handle to the figure plotted
% 
% Input
% DATA  Matrix parsed from the data url containing records for each float at a certain time
% PLOTORNOT  if 1 then a graph of latitude vs longitude is plotted, otherwise not
%
% Output
% LATS   Vector of the latitudes of the floats as from the data
% LONGS  Vector of the longitudes of the floats as from the data
% FIG    Handle to the latitude vs longitude plot
% 
% Authored by Peter Mwesigwa
% Last modified June 18 2019
%

lats = str2num(char(data(:,4)));
longs = str2num(char(data(:,5)));

defval('plotornot', 0)

if plotornot == 1
fig = figure()
ha  = plot(longs, lats, 'kx');
title('Float positions');
ylabel('Latitude');
xlabel('Longitude');
 else 
   fig = 'No Figure Available';
end

