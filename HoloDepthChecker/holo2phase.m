function [ phaseMap ] = holo2phase( holoimage, fringeFrequency )
%HOLO2DEPTH Calculates a phase map from the passed in holoimage
%
%   Arguments:
%       holoimage - Holoimage with colors ranging from 0 - 1
%       fringeFrequency - Frequency of the fringe in the holoimage
%
%   Returns
%       phaseMap - Phase map calculated from Holoimage

stepHeight = (1.0 / fringeFrequency) - .001; % .001 is just a buffer so we dont get rounding errors. At higher frequencies this causes errors
k = floor(holoimage(:,:,3) * 1.0 / stepHeight);

% Add pi so that our phase starts at 0 instead of -pi
phaseMap = atan2(holoimage(:,:,1) - .5, holoimage(:,:,2) - .5) + (2 * pi * k) + pi;
end

