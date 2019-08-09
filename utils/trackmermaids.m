function varargout  = trackmermaids(pred_date, max_dist)

% Description:
% Gets the current position of all the mermaid as well as returning
% their expected position on a specific date. Returns floats that
% are predicted to be within a certain threshold distance of the
% ship's path. 
%
% Inputs
% PREDDATE  A string representing the date on which predictions for the
% float location are to be made. Format must be in DD-MM-YYYY or
% DD-MMM-YYYY HH:MM:SS%. The default date is 18-August-2019, the
% date at which the expedition aims to intercept P023 and P024.
% MAXDIST  The maximum distance (in km) which a float must be from the
% ships path in order to be displayed on the graph. Default
% value is 10
%
% Output:
% FLOATNAMES  The floats of interest which will be within the
% threshold distance from the ships path at the time of prediction
% COORDS  A 2-column matrix containing the latitude and longitude
% respectively of the predicted position of each of the floats of
% interest
% DISTANCES  The distances in km of the predicted locations of each
% of the floats of interest from the ship path.
%
% Last modified by mwesigwa@princeton.edu on Aug 06 2019
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
         

% current date
today = date();

defval('max_dist', 100)

try
    
    if isstring(pred_date) || ischar(pred_date)
        dnum = datenum(datetime(pred_date));
    elseif isa(pred_date, 'double')
        dnum = datenum(datetime(ship_times(pred_date)));
    end
catch
    dnum = datenum(datetime('18-Aug-2019 12:00:00'));
end

% number of points plotted to depict the accurate path of each float
path_pts = round(dnum) - datenum(today);

if path_pts < 1
    error("Prediction must be at least one day in the future");
end

% data detailing the current position of the floats 
current_data = parsemermaiddata("All");

% names of the floats
float_names = char(current_data(:,1))

[n x] = size(float_names)

longs = NaN(path_pts+1, n);
lats = NaN(path_pts+1, n);


longs(1,:) = str2num(char(current_data(:,5)));
lats(1,:) = str2num(char(current_data(:,4)));

% wraparound for longitude values
longs(longs < 0) = longs(longs < 0) + 360;

lastdates = zeros(size(longs));

for i=1:n

    [longFit, latFit, lastdates(i)] = mermpred(float_names(i,:));
    [~, mean_err_fit, std_err_fit] = mermpred(float_names(i,:), 5);

    if dnum==0
        num_days = 7;
    else
        num_days = dnum - lastdates(i);
    end

    times = linspace(0, num_days, path_pts);
    longs(2:(path_pts+1),i) = evalpol(longFit, times);
    lats(2:(path_pts+1),i) = evalpol(latFit, times);
end

% convert from serial date numbers to date strings
lastdates=datestr(lastdates);

pred_date = datestr(dnum);

[distances, mid_x, mid_y] = dist2path(longs(end,:)', lats(end,:)', ...
                            lon_ships', lat_ships');
                        

indices = (1:n)';
ind = indices(distances < max_dist);

% filter out the distances that we want
longs = longs(:,ind);
lats = lats(:,ind);
float_names = float_names(ind,:);
distances = distances(ind);
mid_x = mid_x(ind);
mid_y = mid_y(ind);

% co-ordinates of the mermaid labels
long_labels = longs(1,:)+0.5;
lat_labels = lats(1,:)-0.5;

% plot the data
plot(longs, lats, 'k:', 'LineWidth', 2);
grid on
axis('equal');
hold on
p1 = plot(longs(1,:), lats(1,:), 'rd', ...
    'MarkerFaceColor', 'r', ...
    'MarkerSize', 7);
p2 = plot(longs(end,:), lats(end,:), 'ks', ...
    'MarkerFaceColor', 'k', ...
    'MarkerSize', 7);
p3 = plot(lon_ships, lat_ships, 'b*-.', ...
    'MarkerSize', 1);
plot([long_labels;longs(1,:)], [lat_labels;lats(1,:)], 'r--')
plot([mid_x';longs(end,:)], [mid_y';lats(end,:)], 'm:')
text(long_labels', lat_labels', ...
    strcat(float_names, num2str(distances, '\r\n(%.1f km)')), ...
    'Color', 'r', ...
    'FontSize', 7);
text(lon_ships+0.2, lat_ships+0.2, ship_times, ...
    'Color', 'b', ...
    'FontSize', 8)
hold off
title(strcat("Predicted Mermaid locations for ",pred_date, ...
    " made on ", today, " for within ", num2str(max_dist), ...
    " km of the ship's path."));

legend([p1, p2, p3], ...
    {'Current Location', 'Predicted Location', 'Ship Path'})
xlabel("Longitude in degrees");
ylabel("Latitude in degrees");
% optional output
pLongs = longs(end,:); 
pLongs(pLongs > 180) = pLongs(pLongs > 180) - 360; %remove wraparound
co_ords = [lats(end,:);pLongs]';
varns = {float_names, co_ords, distances};
varargout = varns(1:nargout);