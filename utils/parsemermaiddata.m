function varargout = parsemermaiddata(instr)

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
defval('instr','P025')
nan_found = 0;

LAT_COL = 4;
LON_COL = 5;
% read in the data from the url
try
    if strcmp(instr, "All") == 1
        meth = 2;
        url = 'http://geoweb.princeton.edu/people/simons/SOM/all.txt';
    else 
        meth = 1; 
        url = strcat('http://geoweb.princeton.edu/people/simons/SOM/', ...
                instr, '_030.txt');
    end
   
    data_received = webread(url);
    
    % get the number of rows for the data
    split_data = strsplit(data_received, '\n');
    rows = length(split_data);

    % get the number of columns for the data
    d=strsplit(split_data{1}, ' ');
    cols = length(d);

    

    date = "no date";
    
    filled = 1;
    switch meth
      case 1 % filters nans and multiple dates
        data = strings(rows-1, cols);
        for i = 1:rows-1
          d = char(strsplit(split_data{i}, ' '));
          if isnan(str2num(d(LAT_COL,:)))==1
              nan_found = 1;
              continue
          elseif isnan(str2num(d(LON_COL,:)))==1
              nan_found = 1;
              continue
          elseif strcmp(date, d(2,:)) == 1
              continue  
          end
          data(filled,:) = d;
          date = d(2,:);
          filled = filled + 1;
        end
       
        
        
      case 2 % default
        data = strings(rows-1, cols);
        for i = 1:rows-1
          d = char(strsplit(split_data{i}, ' '));
          if strcmp(d(1,1), "N")
              d(1,1) = 'P';
          elseif strcmp(d(1,1:4), "P007")
             continue
          elseif i > 23
              continue
          end
          data(filled,:) = d;
          filled = filled + 1;
        end
    end
    data=data(1:filled-1,:);
catch e
    fprintf(2, "%s\n", e.message)
    data = "Not found";
end

if nan_found == 1
    fprintf(2, "%Rows with NaN found and removed\n");
end

% Optional output
varns={data,url};
varargout=varns(1:nargout);