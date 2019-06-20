function [dx, dy] = orient(m, c, x, y)
% function [dx, dy] = orient(m1, c1)
%
% Description
% This function takes in a point and the equation of the line and then
% provides components that would take you in a direction perpendicular to a
% line away from the side of the line on which the point lies
%v
% Inputs:
% M    Gradient of the line
% C    y-intercept of the line
% X    x-coordinate of the point
% Y    y-coordinate of the point
% 
% Outputs:
% The xComponent of the vector that would take you away from the line
% The yComponent of the vector that would take you away from the line
%
% Last modified by mwesigwa@princeton.edu Jun 20 2019
%

% gradient of the perpendicular line


m1 = -1/m;
c1 = c + x * (m + 1/m);

dx = 1/sqrt(1+m1^2);
if y > m1*x + c1
    dx = - dx;
end
dy = m1 * dx;


