function varargout = dist2path(ptx, pty, pathx, pathy)
% 
% Computes the shortest distance between paths of two points
%
% Inputs
% PTX and PTY are the x and y co-ordinates of the points in question. If 
% more than one point then these are vectors of the respective x and y 
% co-ordinates of each of the points
%
% PATHX and PATHY are the vectors of the respective x and y co-ordinates of
% each point in the path
%
% Outputs
% DIST: the shortest perpendicular distance between each point and each
% line segment
%
%

% number of points whose distance to the path is needed
n_pts = length(ptx);

% length of the path (number of segments)
n_path = length(pathx)-1;

% distance of each point to each segment of the path
distances = NaN(n_pts, n_path);

% x-co-ordinate of closest point to each segment
mid_x = NaN(n_pts, n_path);

% y-co-ordinate of closest point to each segment
mid_y = NaN(n_pts, n_path);

% get the distances and midpoints to each segment
for i=1:n_path
    lx = pathx(i:i+1);
    ly = pathy(i:i+1);
    [distances(:,i), mid_x(:,i), mid_y(:,i)] = dist2line(ptx, pty, lx, ly);
end

% remove the min distances and their locations
[min_dist, indices] = min(distances, [], 2);

% get the points along the path closest to these points
mid_x = mid_x(sub2ind(size(mid_x), (1:n_pts)', indices));
mid_y = mid_y(sub2ind(size(mid_y), (1:n_pts)', indices));


varns = {min_dist, mid_x, mid_y};
varargout = varns(1:nargout);




