function [error] = calculateError(coordIdeal, coord, mask)
%CALCULATEERROR Calculates the MSE between the two sets of coords
%   
%   Arguments:
%       coordIdeal  - Ideal set of coordinates
%       coord       - Captured set of coordinates
%
%   Returns:
%       mse         - Mean squared error between coordinates

diff = coordIdeal-coord;  
diff = diff .* mask;        % Mask values according to the mask

observations = sum(sum(mask));

observedMean = sum(sum(diff)) / observations;

diff = diff.^2;
error = sum(sum(diff)) - (observations * (observedMean.^2));

error = sqrt(error / (observations - 1));