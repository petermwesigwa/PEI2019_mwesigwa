function [plt quiv] = plotpath(float_name, longs, lats, dLongs, dLats, fig)
% function [plt quiv] = plotpath(x, y, dx, dy)

plt = plot(longs, lats, 'rx');
hold on;
quiv = quiver(longs, lats, dLongs, dLats, 'AutoScale',' on', 'AutoScaleFactor', 0.5);
hold off;
title(strcat('Mermaid locations over 30 days with expected trajectories for', ' ', float_name))
ylabel('Latitude')
xlabel('Longitude')
%text(longs, lats, labels)