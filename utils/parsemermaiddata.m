function varargout= parsemermaiddata(url)
% [data,url] = parsemermaiddata(url)
%
% This function reads in data from a url in the form of a text file
% and stores the information in a cell
% 
% Inputs:
% URL   The remote url from which the data is going to be recieved
%
% Outputs:
% DATA  The matrix containing the data for the url
% URL   The remote url from which the data is going to be recieved
%
% Authored by Peter Mwesigwa. 
% 
% Last modified on June 18 2019

% Example URL
defval('url','http://geoweb.princeton.edu/people/simons/SOM/P017_030.txt')

data_received = webread(url);
split_data = strsplit(data_received, '\n');
rows = length(split_data);
d=strsplit(split_data{1}, '  ');
cols = length(d);

defval('meth',2)
tic
switch meth
  case 1
    % Vectorized, which you hope to be faste
    % data=textscan;
  case 2
    data = cell(rows-1, cols);
    for i = 1:rows-1
      d = strsplit(split_data{i}, '  ');
      for j = 1:cols
        data(i,j) = d(j);
      end
    end
end
toc
    
% Optional output
varns={data,url};
varargout=varns(1:nargout);