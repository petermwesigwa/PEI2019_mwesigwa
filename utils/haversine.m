function dist = haversine(lat1, long1, lat2, long2)
% function dist = haversine(lat1, long1, lat2, long2)
%  
% Computes the haversine distance between two latitude and longitude pairs
%
% Inputs:
% LAT1 Latitude of point 1
% LONG1 Longitude of point 1
% LAT2 Latitude of point 2
% LONG2 Longitude of point 2
%
% Output:
% DIST Distance between the two points in meters
%
% Last modified by mwesigwa@princeton.edu Jul 17 2019
%

dlat = deg2rad(lat2-lat1);
dlon = deg2rad(long2-long1);
lat1 = deg2rad(lat1);
lat2 = deg2rad(lat2);
a = (sin(dlat./2)).^2 + cos(lat1) .* cos(lat2) .* (sin(dlon./2)).^2;
c = 2 .* asin(sqrt(a));
dist = 6372.8 * c * 1000; % convert to m 