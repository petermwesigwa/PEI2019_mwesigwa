function dist = ptdist(x1, y1,x2, y2)
% function dist = ptdist(x1, y1,x2, y2)
% 
% distance between two points
%

dx = x2 - x1;
dy = y2 - y1;
dist = sqrt(dx.^2 + dy.^2);