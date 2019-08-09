function varargout = mat2dat(filename, name, lats, longs, distances)
% function fileName = mat2dat(matrix)
% Converts a matrix of strings into a data file in matlab

defval('filename', 'mydata.dat')
filename = char(filename);
if ~strcmp(filename(end-3:end), '.dat')
  filename = strcat(filename, 'dat')
end

defval('name', ['P023'; 'P024']);
defval('lats', [-11.211; -13.211]);
defval('longs', [-131.211; -133.010]);
defval('distances', [23.9; 22.1]);

n = length(distances);
fid = fopen(filename, 'w');

for i =  1:n
  fprintf(fid, '%.3f %.3f %.3f %s\n', lats(i), longs(i), distances(i), ...
          name(i,:));
end
fclose(fid);

varns ={filename};
varargout = varns(1:nargout);