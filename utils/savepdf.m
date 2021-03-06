function [filename] = savepdf(fig, filename)
% function [filename] = savepdf(fig, filename)
%
% This function saves a figure as a pdf in the desktopn
%
% Input:
% FIG   Handle to the figure that is going to be saved to PDF
% FILENAME    Filename of the stored pdf
% 
% Output:
% FILENAME Filename to the stored pdf
%% 
% Authored by Peter Mwesigwa. Last modified Jun 17 2019

  print(fig, '-dpdf', strcat('~/Desktop/',filename))
