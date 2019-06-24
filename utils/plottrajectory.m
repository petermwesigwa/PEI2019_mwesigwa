function varargout= plottrajectory(data, points, degree, fig)
% [plt quiv] = plottrajectory(data, points, degree, fig)
%
% Description
% 
% Uses the vector of latitudes and longitudes to create a prediction
% for some data points as to where the mermaid will go next.
% 
% Inputs
% DATA - the cell data from the mermaid url [from PARSEMERMAIDDATA]
% POINTS - number of points used in the prediction [default: 4]
% DEGREE - degree of the polynomial used for the fit [default: 1]
% FIG - the figure which will contain the plots(if any) [default: gcf]
%
% Outputs
% PLT = the  plot handle of latitudes and longitudes
% QUIV = the quiver plot for the trajectories
%
% EXAMPLE:
%
% a=parsemermaiddata;
% plottrajectory(a,3,2)
%
% Last modified by Peter Mwesigwa on Jun 21 2019

defval('data',parsemermaiddata)
defval('points',4)
defval('degree',1)
defval('fig',gcf)

lats=str2num(char(data(:,3)));
longs=str2num(char(data(:,4)));
labels=char(data(:,2));

n=size(lats);
xComp=str2double(cell(n));
yComp=str2double(cell(n));
% [xComp,yComp]=deal(nan(n(1),1));
r_squared=string([n, 1]);
for i=1:points-1
  xComp(i) = 0;
  yComp(i) = 0;
  r_squared(i) = 'None';
end

for i=points:n-points
  dates = datetime(char(data(i-points+1:i+points,2)));
  times = seconds(dates - dates(1));

  % Generate fit to lon lat with time
  warning off MATLAB:nearlySingularMatrix     
  fit1 = generateL2(times(1:points), longs(i-points+1:i), degree);
  fit2 = generateL2(times(1:points), lats(i-points+1:i), degree);
  warning on MATLAB:nearlySingularMatrix     

  % Evaluate fit
  lat_error = testfit(times(points+1:(2*points)), lats(i+1:i+points), fit2);
  long_error = testfit(times(points+1:(2*points)), longs(i+1:i+points), fit1);
  
  % Use fit to calculate speed and location production
  xComp(i) = derivative(fit1, times(points));
  yComp(i) = derivative(fit2, times(points));
  
  % Report error
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

% Plotting
plt = plot(longs, lats, 'rx');
hold on;
quiv = quiver(longs, lats, xComp, yComp, 'AutoScale',' on', ...
              'AutoScaleFactor', 0.5);
hold off;
title(strcat(...
    'Mermaid locations over 30 days with expected trajectories for', ' ',...
    data{1,1}))
ylabel('Latitude')
xlabel('Longitude')
text(longs, lats, r_squared)

% Optional output
varns={plt,quiv};
varargout=varns(1:nargout);

