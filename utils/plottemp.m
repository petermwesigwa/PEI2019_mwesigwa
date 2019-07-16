function varargout = plottemp(col, data)
% function varargout = plottemp(data)
% fill in all this stuff later


defval('data', file2mat());

temp = str2num(char(data(3:end,col)));
time = str2num(char(data(3:end,1)));

switch col
  case 8
    label = 'Temperature'
  case 9
    label = 'Pressure'
end

plt = plot(time, temp, 'k-');
title(strcat('A plot of ', label, ' against time'));
xlabel('Time');
ylabel(label);

varns = {plt};
varargout = varns(1:nargout);