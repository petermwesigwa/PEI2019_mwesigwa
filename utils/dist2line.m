function varargout = dist2line(ptx, pty, lx, ly)
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

%if length(ptx) ~= 1 || length(pty ~= 1)
 %   error('You must provide one x and y co-ordinate for the point')

 %elseif length(lx) ~= 2 || length(ly ~= 2)
  %  error('You must provide two x and y co-ordinate for the line')
%end

dy = (ly(2) - ly(1));
dx = (lx(2) - lx(1));

if dx == 0 && dy == 0
    error("The ends of the line must be different points")
end

if dy == 0
    a = 0;
    b = 1;
    c = ly(1);
elseif dx == 0
    a = 1;
    b = 0;
    c = -lx(1);
else
    a = -dy/dx;
    b = 1;
    c = -a * lx(1) - ly(1);
end

denom = a.^2+ b.^2;

mid_x = (b.^2 .* ptx - a.*b .* pty - a.*c)./denom;
mid_y = (-a.*b .* ptx + a.^2 .* pty - b.*c)./denom;

var = 0;
if var == 0
if dx < 0
    bool = mid_x < lx(2);
    mid_x(bool) = lx(2);
    mid_y(bool) = ly(2);
    bool = mid_x > lx(1);
    mid_x(bool) = lx(1);
    mid_y(bool) = ly(1);
elseif dx > 0
    bool1 = mid_x > lx(2);
    mid_x(bool1) = lx(2);
    mid_y(bool1) = ly(2);
    bool2 = mid_x < lx(1);
    mid_x(bool2) = lx(1);
    mid_y(bool2) = ly(1);
elseif dy > 0
    bool = mid_y > ly(2);
    mid_x(bool) = lx(2);
    mid_y(bool) = ly(2);
    bool = mid_y < ly(1);
    mid_x(bool) = lx(1);
    mid_y(bool) = ly(1);
elseif dy < 0
    bool = mid_y < ly(2);
    mid_x(bool) = lx(2);
    mid_y(bool) = ly(2);
    bool = mid_y > ly(1);
    mid_x(bool) = lx(1);
    mid_y(bool) = ly(1);
end
end

dist = haversine(ptx, pty, mid_x, mid_y) / 1000;


defval('xver', 0)
if xver == 1
    plot(lx, ly, 'bx-');
    hold on;
    grid on;
    plot([ptx'; mid_x'], [pty'; mid_y'], 'r*:');
    axis([-10 10 -10 10], 'equal')
    hold off;
end

varns = {dist, mid_x, mid_y};
varargout = varns(1:nargout);



    

