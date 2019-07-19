function varargout = file2mat(filename)

% function [data] = parsemermaiddata(url)
% This function reads in data from a url in the form of a text file and stores the information in a matrix
% 
% Inputs:
% FILENAME The path to the file whose data is to be read in
%
% Outputs:
% DATA  The matrix containing the data for the url
% FILENAME   The name of the file from which the data was read in
%
% Example usage:
% [data filename] =
% parsemermaiddata('/home/mwesigwa/PEI2019_mwesigwa/data2/Processed_Weather_Data/pton2480.17__SBF_ASCIIIn.txt')
%
%
% Last modified by mwesigwa@princeton.edu on Jun 24 2019

% Example filename
defval('filename', '/home/mwesigwa/PEI2019_mwesigwa/data2/Processed_Weather_Data/pton2480.17__SBF_ASCIIIn.txt')

% read in the data from the file
data_received = fileread(filename);

% get the number of rows for the data
split_data = strsplit(data_received, '\n');
rows = length(split_data);

% get the number of columns for the data
d=strsplit(split_data{3});
cols = length(d);

defval('meth',2)

switch meth
  case 2
    data = cell(rows-3, cols);
    for i = 3:rows-1
      d = strsplit(split_data{i});
      for j = 1:cols
        data(i,j) = d(j);
      end
    end
end

    
% Optional output
varns={data,filename};
varargout=varns(1:nargout);