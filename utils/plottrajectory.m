function [xComp yComp, m] = trajectories[lats longs]
  % function [xComp yComp, m] = trajectories[lats longs]
% 
% Description
% 
% Uses the vector of latitudes and longitudes to create a prediction for some data points as to where % the mermaid will go next.
% 
% Inputs
% LATS - Vector of the latitudes of the float
% LONGS - Vector of the longitudes of the float
%
% Outputs
% xComp - x-components of the predictions for select points
% yComp - y-components of the predictions for select points
% m = the gradient of the prediction line for select points
%
% Last modified by Peter Mwesigwa June 19 2019
%
 
