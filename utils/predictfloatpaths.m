function varargout = predictfloatpaths(data, trainSize, ...
                                       degree, xver)
% function [longs, lats, dLongs, dLats, stats] = 
% predictfloatpaths(data, trainSize, testSize, degree, xver)
% 
% Description
% 
% Given the data reported by a mermaid, produces its locations with
% time. Generates a model that is used to estimate the speed and direction in which the
% mermaid is traveling for each observed position and tests the
% model to see how accurate it was in predicting where the mermaid
% would end up next.
% 
% Inputs
% DATA - the data as returned by PARSEMERMAIDDATA
% TRAINSIZE - size of the training set
% TESTSET - size of the test set
% DEGREE - degree of the polynomial used for the fit
% XVER Extra verification - prints additional tests if 1, otherwise
% not
%
% Outputs
% LONGS  The longitudes of the floats
% LATS  The latitudes of the floats
% DLONGS  The rates of change in longitude for each float
% (longitude component of velocity)
% DLATS  The rates of change in latitude for each float (latitude
% component of velocity)
% STATS A 6 column matrix detailing stats measuring the accuracy of
% the model. The columns are coefficient of determination, mean
% error and standard deviation of errors respectively, and an error
% scaling factor with time
% |   r^2        |   mean       |   stddev     | error factor |
% | longs | lats | longs | lats | longs | lats | longs | lats |
%
% Usage
% [lon lat dLong dLat] = predictfloatpaths(data, trainSize,
% testSize, degrre) return longitudes and latitudes of each
% observation, as well as longitudinal and latitudinal components
% of the float's velocity.
% 
% Last modified by Peter Mwesigwa  on Jul 1 2019
%

% set default values for some parameters using the DEFVAL function
defval('trainSize', 7)
defval('degree', 2)
defval('xver', 0)

% read latitudes reported by observations
lats=str2num(char(data(:,4)));

% read longitudes reported by observations
longs=str2num(char(data(:,5))); 

% wraparound for longitude values
longs(longs < 0) = longs(longs < 0) + 360;

% read times at which observations were reported
% Convert these times into date numbers using DATETIME and DATENUM functions
times=datenum(datetime(char(data(:,2))));

% number of observations
n=length(lats);

% preallocate space for return variables
dLongs=NaN(n,1);
dLats=NaN(n,1);

for i=trainSize:n
  % get predictions for both the longitude and latitude variation with
  % time
  fitLongs = generateL2(times(i-trainSize+1:i), longs(i-trainSize+1:i), degree);
  fitLats = generateL2(times(i-trainSize+1:i), lats(i-trainSize+1:i), degree);
  
  % compute the gradient parallel to the line of best fit
  dLongs(i) = derivative(fitLongs, times(i));
  dLats(i) = derivative(fitLats, times(i));
end

% optional output
varns = {longs, lats, dLongs, dLats};
varargout = varns(1:nargout);