function varargout = predictfloatpaths(data, trainSize, testSize, ...
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
% Last modified by Peter Mwesigwa  on Jun 28 2019
%

defval('trainSize', 7)
defval('testSize', 10)
defval('degree', 2)
defval('xver', 0)

% preallocate space for all arrays
lats=str2num(char(data(:,3)));
longs=str2num(char(data(:,4))); 
n=length(lats);
dLongs=NaN(n,1);
dLats=NaN(n,1);
FitLongs=NaN(n, degree+1);
FitLats=NaN(n, degree+1);
stats=NaN(n-(trainSize+testSize),8);

for i=trainSize:n-testSize
  % generate the time in seconds as an independent variable
  dates = datetime(char(data(i-trainSize+1:i+testSize,2)));
  times = hours(dates - dates(trainSize));
  
  % get predictions for both the longitude and latitude variation with
  % time
  fitLongs(i,:) = generateL2(times(1:trainSize), longs(i-trainSize+1:i), degree);
  fitLats(i,:) = generateL2(times(1:trainSize), lats(i-trainSize+1:i), degree);
  
  % get accuracies when tested in the test set
  [stats(i+1-trainSize,2), ...
       latErrors] = testfit(times((trainSize+1):(trainSize+testSize)), ...
      lats(i+1:i+testSize), fitLats(i,:));
  [stats(i+1-trainSize,1), ...
      longErrors] = testfit(times((trainSize+1):(trainSize+testSize)), ...
      longs(i+1:i+testSize), fitLongs(i,:));
  
  stats(i+1-trainSize, 3) = mean(longErrors);
  stats(i+1-trainSize, 4) = mean(latErrors);
  stats(i+1-trainSize, 5) = std(longErrors);
  stats(i+1-trainSize, 6) = std(latErrors);
  
  % create fits for errors to see how they scale with time
  longErrorFit = generateL2(log(times((trainSize+1):(trainSize+ ... 
                                                 testSize))-times(trainSize)), ...
                            log(longErrors), 1, xver);
  latErrorFit = generateL2(log(times((trainSize+1):(trainSize+ ...
                                                testSize))-times(trainSize)), ...
                           log(latErrors), 1, xver);
  stats(i+1-trainSize, 7) = longErrorFit(1);
  stats(i+1-trainSize, 8) = latErrorFit(1);
  
  % compute the gradient parallel to the line of best fit
  dLongs(i) = derivative(fitLongs(i,:), times(trainSize));
  dLats(i) = derivative(fitLats(i,:), times(trainSize));
  
end

for i=n-testSize+1:n
  % generate the time in seconds as an independent variable
  dates = datetime(char(data(i-trainSize+1:i,2)));
  times = seconds(dates - dates(trainSize));

  % get predictions for lat and long variation at each point with time
  fitLongs(i,:) = generateL2(times(1:trainSize), longs(i-trainSize+1:i), degree);
  fitLats(i,:) = generateL2(times(1:trainSize), lats(i-trainSize+1:i), ...
                       degree);
  % compute the gradient parallel to the lines of best fit
  dLongs(i) = derivative(fitLongs(i,:), times(trainSize));
  dLats(i) = derivative(fitLats(i,:), times(trainSize));
end


% optional output
varns = {longs, lats, dLongs, dLats, fitLongs, fitLats, stats};
varargout = varns(1:nargout);