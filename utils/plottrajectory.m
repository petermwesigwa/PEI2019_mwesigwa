function [plt, quiv] = plottrajectory(data, points, degree, fig)
  % function [plt quiv] = plottrajectory(data, points, degree, fig)
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
% FIG = the figure plotted or 'No Figure' if none is plotted
% PLT = the plot of latitudes and longitudes
% QUIV = the quiver plot for the trajectories
%
%
% Last modified by Peter Mwesigwa  on Jun 21 2019
%

lats=str2num(char(data(:,3)));
longs=str2num(char(data(:,4)));
labels=char(data(:,2));
 
  n=size(lats);
xComp=str2double(cell(n));
yComp=str2double(cell(n));
r_squared=string([n, 1]);
for i=1:points-1
    xComp(i) = 0;
    yComp(i) = 0;
    r_squared(i) = 'None';

end


for i=points:n-points
    dates = datetime(char(data(i-points+1:i+points,2)));
    times = seconds(dates - dates(1));
	fit1 = generateL2(times(1:points), longs(i-points+1:i), degree);
    fit2 = generateL2(times(1:points), lats(i-points+1:i), degree);
    
    lat_error = testfit(times(points+1:(2*points)), lats(i+1:i+points), fit2);
    long_error = testfit(times(points+1:(2*points)), longs(i+1:i+points), fit1);
    
    
    xComp(i) = derivative(fit1, times(points));
    yComp(i) = derivative(fit2, times(points));
    r_squared(i) = strcat(num2str(long_error), ", ", num2str(lat_error));
    
end

for i=n-points+1:n
    dates = datetime(char(data(i-points+1:i,2)));
    times = seconds(dates - dates(1));
	fit1 = generateL2(times(1:points), longs(i-points+1:i), degree);
    fit2 = generateL2(times(1:points), lats(i-points+1:i), degree);
    xComp(i) = fit1(1);
    yComp(i) = fit2(1);
    r_squared(i) = 'None';
end
    
plt = plot(longs, lats, 'rx');
hold on;
quiv = quiver(longs, lats, xComp, yComp, 'AutoScale',' on', 'AutoScaleFactor', 0.5);
hold off;
title(strcat('Mermaid locations over 30 days with expected trajectories for', ' ', data{1,1}))
ylabel('Latitude')
xlabel('Longitude')
%text(longs, lats, r_squared)

