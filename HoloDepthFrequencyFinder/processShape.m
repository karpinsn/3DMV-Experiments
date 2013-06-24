function [ MSE ] = processShape( depthMap, mask, frequency )
%PROCESSSHAPE Holoencodes the specified depth map, writes and reads it,
%then compares the recovered depth map to calculate an MSE
%
%   Arugments:
%       depthMap - Depthmap of a shape, scan, or scene with values
%                  ranging from 0 - 1
%       mask - Mask of 0 or 1 corresponding to which values should be
%       considered
%       frequency - Frequency to use during encoding and decoding
%
%   Returns:
%       MSE - Mean squared error after holoencoding

holo = holoEncode(depthMap, frequency);
holo2output(holo, 'temp.png');
holo = output2holo('temp.png');
phase = holo2phase(holo, frequency);
phase = phaseMedFilter(phase, 7);
phase = phaseMedFilter(phase, 7);
recoveredDepth = phase2depth(phase, frequency);

MSE = calculateError(depthMap, recoveredDepth, mask);
end