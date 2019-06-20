function [plt, quiv] = plottrajectory(data, points, fig)
  % function [plt quiv] = plottrajectory(data, points, fig)
% 
% Description
% 
% Uses the vector of latitudes and longitudes to create a prediction for some data points as to where % the mermaid will go next.
% 
% Inputs
% DATA - the data from the mermaid url
% POINTS - number of points used in the prediction
% FIG - the figure which will contain the plots(if any)
%
% Outputs
% FIG = the figure plotted or 'No Figure' if none is plotted
% PLT = the plot of latitudes and longitudes
% QUIV = the quiver plot for the trajectories
%
%
% Last modified by Peter Mwesigwa  on Jun 19 2019
%

  lats=str2num(char(data(:,4)));
longs=str2num(char(data(:,5)));
labels=char(data(:,2));
 
  n=size(lats);
xComp=str2double(cell(n));
yComp=str2double(cell(n));

for i=1:points-1
    xComp(i) = 0;
    yComp(i) = 0;

end


for i=points:n
	xT = [transpose(lats(i-points+1:i));linspace(1,1, points)];
x = transpose(xT);
y = longs(i-points+1:i);

% Compute the linear fit for all these points
xTx = xT*x;
xTy = xT*y;
result = xTx\xTy
m = result(1);
c = result(2);
dx = 0.001/sqrt(1+m^2)

if y(i - 1) > m * x(i-1) + c
    dx = -dx;
end

dy = m * dx;
xComp(i) = dx;
yComp(i) = dy;

end

plt = plot(lats, longs, 'rx');
hold on
quiv = quiver(lats, longs, xComp, yComp, 'AutoScale',' on', 'AutoScaleFactor', 0.2);
hold off;
title('Mermaid locations over 30 days with expected trajectories')
ylabel('Latitude')
xlabel('Longitude')
text(lats, longs, labels, 'FontSize', 8)
