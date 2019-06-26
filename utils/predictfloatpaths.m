function varargout = predictfloatpaths(data, points, degree)
% function [longs, lats, dLongs, dLats, stats] = predictfloatpaths(data, points, degree)
% 
% Description
% 
% Uses the vector of latitudes and longitudes to create a prediction for some data points as to where % the mermaid will go next.
% 
% Inputs
% DATA - the data as returned by PARSEMERMAIDDATA
% POINTS - number of points used in the prediction
% DEGREE - degree of the polynomial used for the fit
% 
% Outputs
% LONGS  The longitudes of the floats
% LATS  The latitudes of the floats
% DLONGS  The rates of change in longitude for each float
% DLATS  The rates of change in latitude for each float
% MEANERRLON The mean error of the longitude prediction for each
% observation
% MEANERRLAT The mean error of the latitude prediction for each observation
% SDERRLON the standard deviation of the errors in the longitude
% prediction of each point
% SDERRLAT The standard deviation of the errors in the latitude
% prediction of each point
% R2LONGS  The r^2 values of the longitude predictions for each float
% R2LATS  The r^2 values of the latitude predictions for each float
%
% Last modified by Peter Mwesigwa  on Jun 26 2019
%

defval('points', 7)
defval('degree', 2)

% preallocate space for all arrays
lats=str2num(char(data(:,3)));
longs=str2num(char(data(:,4))); 
n=length(lats);
dLongs=NaN(n,1);
dLats=NaN(n,1);

stats=NaN(n-(2*points),6);

for i=points:n-points
  % generate the time in seconds as an independent variable
  dates = datetime(char(data(i-points+1:i+points,2)));
  times = seconds(dates - dates(1));
  
  % get predictions for both the longitude and latitude variation with
  % time
  fitLongs = generateL2(times(1:points), longs(i-points+1:i), degree);
  fitLats = generateL2(times(1:points), lats(i-points+1:i), degree);
  
  % get accuracies when tested in the test set
  [stats(i-points+1,2), stats(i+1-points,4), stats(i+1-points,6) ] = testfit(times(points+1:(2*points)), lats(i+1:i+points), fitLats);
  [stats(i+1-points,1), stats(i+1-points,3), stats(i+1-points,5)] = testfit(times(points+1:(2*points)), longs(i+1:i+points), fitLongs);
  
  % compute the gradient parallel to the line of best fit
  dLongs(i) = derivative(fitLongs, times(points));
  dLats(i) = derivative(fitLats, times(points));
  
end

for i=n-points+1:n
  % generate the time in seconds as an independent variable
  dates = datetime(char(data(i-points+1:i,2)));
  times = seconds(dates - dates(1));

  % get predictions for lat and long variation at each point with time
  fitLongs = generateL2(times(1:points), longs(i-points+1:i), degree);
  fitLats = generateL2(times(1:points), lats(i-points+1:i), ...
                       degree);
  % compute the gradient parallel to the lines of best fit
  dLongs(i) = derivative(fitLongs, times(end));
  dLats(i) = derivative(fitLats, times(end));
end


% optional output
varns = {longs, lats, dLongs, dLats, stats};
varargout = varns(1:nargout);