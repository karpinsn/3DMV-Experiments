function [ depthMap ] = phase2depth( phaseMap, frequency )
%PHASE2DEPTH Calculates a depth map from the passed in phase map
%
%   Arguments:
%       phaseMap - Unwrapped phase map
%       frequency - Frequency of the fringe
%
%   Returns:
%       depthMap - Depth map calculated from the phase map

depthMap = phaseMap / (2 * pi * frequency);
end