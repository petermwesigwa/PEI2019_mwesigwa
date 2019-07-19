function float_names = instrNames()
% function varargout = instrNames()
%
% Reads in the names of the mermaid instruments from the url
% http://geoweb.princeton.edu/people/simons/SOM/all.txt

url_all = 'http://geoweb.princeton.edu/people/simons/SOM/all.txt';

% data detailing the current position of the floats 
current_data = parsemermaiddata(url_all);

% names of the floats
float_names = char(current_data(:,1));

