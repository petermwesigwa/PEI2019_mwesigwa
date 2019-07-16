function varargout  = trackmermaids(date)

% Description:
% Gets the current position of all the mermaid as well as returning
% their expected position a set period of time from now
%
% Inputs
% DATE  A string representing the date on which predictions for the
% float location are to be made. Format must be in MM-DD-YYYY or
% MM-DD-YYYY HH:MM:SS% 
% Output:
%
%
% Last modified by mwesigwa@princeton.edu on Jul 01 2019
%

% convert the date into a date number
dnum = datenum(datetime(date));

url_all = 'http://geoweb.princeton.edu/people/simons/SOM/all.txt';

% data detailing the current position of the floats 
current_data = parsemermaiddata(url_all);

% names of the floats
float_names = char(current_data(:,1));


% degree of the polynomial fit for the regression
deg = 2;

n = length(float_names);

longs = str2num(char(current_data(:,4)));
lats = str2num(char(current_data(:,3)));

lon_vel = zeros(size(longs));
lat_vel = zeros(size(lats));

long_pos = zeros(size(longs));
lat_pos = zeros(size(lats));

lat_ships = [-17.3,-12.0,-10.0,-8.0,-6.0,-5.0,-6.0,-8.0,...
             -13.0,-17.0,-22.0,-27.0,-28.0,-29.0,-30.0,...
             -31.0,-30.0,-29.0,-28.0,-27.0,-26.0,-25.65,...
             -25.63,-25.0,-24.0,-22.2];
lon_ships = [-149.3,-151.0,-150.0,-149.0,-148.0,-146.0,...
               -144.0,-139.0,-135.0,-136.0,-141.0,-149.0,...
               -151.0,-154.0,-157.0,-160.0,-164.0,-166.0,...
               -168.0,-170.0,-172.0,-174.9,-177.6,-179.0,...
               -180.0,-193.7];

for i=1:n
  try
    url = strcat('http://geoweb.princeton.edu/people/simons/SOM/', ...
               float_names(i,:), '_030.txt');
    data = parsemermaiddata(url);
    [lon, lat, dLong, dLat, longFit, latFit] = predictfloatpaths(data, ...
                                           15, 0, deg);
    lon_vel(i) = dLong(end);
    lat_vel(i) = dLat(end);                          ;
    long_pos(i) = longs(i) + evalpol(longFit, dnum);
    lat_pos(i) = lats(i) + evalpol(latFit, dnum);

  catch
    lon_vel(i) = NaN;
    lat_vel(i) = NaN;
  end
end

longFit
latFit
dnum

plot(longs, lats, 'bs');
%plot(lon_ships, lat_ships, 'k-');
hold on;
text(longs, lats, float_names);
plot(long_pos, lat_pos, 'rx');
text(long_pos, lat_pos, float_names);
 
%uiver(longs, lats, lon_vel, lat_vel, 'AutoScale', 'on', ...
%     'AutoScaleFactor', 1)
hold off;

% optional output
varns = {float_names};
varargout = varns(1:nargout);