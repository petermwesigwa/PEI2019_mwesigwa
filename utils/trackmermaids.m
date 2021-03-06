function varargout  = trackmermaids(pred_date)

% Description:
% Gets the current position of all the mermaid as well as returning
% their expected position a set period of time from now
%
% Inputs
% DATE  A string representing the date on which predictions for the
% float location are to be made. Format must be in DD-MM-YYYY or
% DD-MMM-YYYY HH:MM:SS% 
% Output:
%
%
% Last modified by mwesigwa@princeton.edu on Jul 01 2019
%

% convert the date into a date number

% ship positions in latitude and longitude
lat_ships = [-17.3,-12.0,-10.0,-8.0,-6.0,-5.0,-6.0,-8.0,...
             -13.0,-17.0,-22.0,-27.0,-28.0,-29.0,-30.0,...
             -31.0,-30.0,-29.0,-28.0,-27.0,-26.0,-25.65,...
             -25.63,-25.0,-24.0,-22.2];
lon_ships = [-149.3,-151.0,-150.0,-149.0,-148.0,-146.0,...
               -144.0,-139.0,-135.0,-136.0,-141.0,-149.0,...
               -151.0,-154.0,-157.0,-160.0,-164.0,-166.0,...
               -168.0,-170.0,-172.0,-174.9,-177.6,-179.0,...
               -180.0,-193.7];
% times for these positions
ship_times = ["5 Aug 08:00", "6 Aug 18:00", "7 Aug 08:00",...
              "7 Aug 23:00", "8 Aug 13:00", "9 Aug 04:00",...
              "10 Aug 08:00", "11 Aug 23:00", "13 Aug 01:00",...
              "14 Aug 19:00", "17 Aug 01:00", "18 Aug 19:00",...
              "19 Aug 08:00", "20 Aug 02:00", "20 Aug 20:00",...
              "21 Aug 14:00", "22 Aug 13:00", "23 Aug 02:00",...
              "23 Aug 15:00", "24 Aug 05:00", "24 Aug 19:00",...
              "25 Aug 12:00", "26 Aug 04:00", "26 Aug 21:00",...
              "27 Aug 14:00", "30 Aug 18:00"];

% wraparound for longitude values
lon_ships(lon_ships < 0) = lon_ships(lon_ships < 0) + 360;
         

try
    
    if isstring(pred_date) || ischar(pred_date)
        dnum = datenum(datetime(pred_date));
    elseif isa(pred_date, 'double')
        dnum = datenum(datetime(ship_times(pred_date)));
    end
catch
    dnum = 0;
end

defval('curr', 0)


% data detailing the current position of the floats 
current_data = parsemermaiddata("All");

% names of the floats
float_names = char(current_data(:,1));

n = length(float_names);

longs = str2num(char(current_data(:,5)));
lats = str2num(char(current_data(:,4)));

% wraparound for longitude values
longs(longs < 0) = longs(longs < 0) + 360;

lastdates = zeros(size(longs));

long_pos = NaN(size(longs));
lat_pos = NaN(size(lats));


for i=1:n

    [longFit, latFit, lastdates(i)] = mermpred(float_names(i,:));

    if dnum==0
        num_days = 7;
    else
        num_days = dnum - lastdates(i);
    end

    long_pos(i) = evalpol(longFit, (num_days));
    lat_pos(i) = evalpol(latFit, (num_days));
end

% convert from serial date numbers to date strings
lastdates=datestr(lastdates);

today = date();
if dnum==0
    pred_date = datestr(datenum(today) + 7);
end
    
% plot the current position of the ship if available

long_labels = longs + 0.5;
lat_labels = lats - 0.5;
longs = [longs';long_pos'];
lats = [lats';lat_pos'];

plot(longs, lats, 'r:', 'LineWidth', 2);
grid on
hold on
p1 = plot(longs(1,:), lats(1,:), 'rd', ...
    'MarkerFaceColor', 'r');
p2 = plot(longs(2,:), lats(2,:), 'ks', ...
    'MarkerFaceColor', 'k', ...
    'MarkerSize', 5);
p3 = plot(lon_ships, lat_ships, 'b*-.', ...
    'MarkerSize', 1);
plot([long_labels';longs(1,:)], [lat_labels';lats(1,:)], 'k--')
text(long_labels, lat_labels, float_names);
text(lon_ships+0.2, lat_ships+0.2, ship_times, ...
    'Color', 'b', ...
    'FontSize', 8)
hold off
title(strcat("Predicted Mermaid locations for ",pred_date, ...
    " made on ", today));

legend([p1, p2, p3], ...
    {'Current Location', 'Predicted Location', 'Ship Path'})
xlabel("Longitude in degrees");
ylabel("Latitude in degrees");
% optional output
varns = {today, lastdates};
varargout = varns(1:nargout);