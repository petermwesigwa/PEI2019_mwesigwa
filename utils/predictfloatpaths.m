function [longs, lats, dLongs, dLats, r2Longs, r2Lats] = predictfloatpaths(data, points, degree, fig)
% function [longs, lats, dLongs, dLats, r2Longs, r2Lats] = predictfloatpaths(data, points, degree, fig)
% 
% Description
% 
% Uses the vector of latitudes and longitudes to create a prediction for some data points as to where % the mermaid will go next.
% 
% Inputs
% DATA - the data from the mermaid url
% POINTS - number of points used in the prediction
% DEGREE - degree of the polynomial used for the fit
% FIG - the figure which will contain the plots(if any)
%
% Outputs
% LONGS: The longitudes of the floats
% LATS: The latitudes of the floats
% DLONGS: The rates of change in longitude for each float
% DLATS: The rates of change in latitude for each float
% R2LONGS: The r^2 values of the longitude predictions for each float
% R2LATS: The r^2 values of the latitude predictions for each float
%
% Last modified by Peter Mwesigwa  on Jun 21 2019
%

lats=str2num(char(data(:,3)));
longs=str2num(char(data(:,4)));
 
  n=size(lats);
dLongs=zeros(n);
dLats=zeros(n);
r2Longs=zeros(n);
r2Lats=zeros(n);

for i=points:n-points
    % generate the time in seconds as an independent variable
    dates = datetime(char(data(i-points+1:i+points,2)));
    times = seconds(dates - dates(1));
    
    % get predictions for both the longitude and latitude variation with
    % time
	fitLongs = generateL2(times(1:points), longs(i-points+1:i), degree);
    fitLats = generateL2(times(1:points), lats(i-points+1:i), degree);
    
    % get accuracies when tested in the test set
    r2Lats(i) = testfit(times(points+1:(2*points)), lats(i+1:i+points), fitLats);
    r2Longs(i) = testfit(times(points+1:(2*points)), longs(i+1:i+points), fitLongs);
    
    % compute the gradient parallel to the line of best fit
    dLongs(i) = derivative(fitLongs, times(points));
    dLats(i) = derivative(fitLats, times(points));
    
end

for i=n-points+1:n
    dates = datetime(char(data(i-points+1:i,2)));
    times = seconds(dates - dates(1));
	fitLongs = generateL2(times(1:points), longs(i-points+1:i), degree);
    fitLats = generateL2(times(1:points), lats(i-points+1:i), degree);
    dLongs(i) = fitLongs(1);
    dLats(i) = fitLats(1);
end
    

%text(longs, lats, r_squared)

