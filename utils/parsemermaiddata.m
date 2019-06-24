function varargout = parsemermaiddata(url)

% function [data] = parsemermaiddata(url)
% This function reads in data from a url in the form of a text file and stores the information in a matrix
% 
% Inputs:
% URL   The remote url from which the data is going to be recieved
%
% Outputs:
% DATA  The matrix containing the data for the url
% URL   The url from which the data was retrieved
%
% Example usage:
% [data url] =
% parsemermaiddata('http://geoweb.princeton.edu/people/simons/SOM/P017_030.txt')
%
% Last modified by mwesigwa@princeton.edu on Jun 24 2019

% Example url
defval('url', 'http://geoweb.princeton.edu/people/simons/SOM/P017_030.txt')

% read in the data from the url
data_received = webread(url);

% get the number of rows for the data
split_data = strsplit(data_received, '\n');
rows = length(split_data);

% get the number of columns for the data
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
