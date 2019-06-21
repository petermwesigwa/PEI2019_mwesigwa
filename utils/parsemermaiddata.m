function [data] = parsemermaiddata(url)

  % function [data] = parsemermaiddata(url)
% This function reads in data from a url in the form of a text file and stores the information in a matrix
% 
  % Inputs:
  % URL   The remote url from which the data is going to be recieved
  %
  % Outputs:
  % DATA  The matrix containing the data for the url
  %
  % Authored by Peter Mwesigwa. 
  % Last modified on June 18 2019

  
  data_received = webread(url);
split_data = strsplit(data_received, '\n');
rows = length(split_data);
d=strsplit(split_data{1}, '  ');
cols = length(d);

data = cell(rows-1, cols);
for i = 1:rows-1
    d = strsplit(split_data{i}, '  ');
    for j = 1:cols
	  data(i,j) = d(j);
    end
end

