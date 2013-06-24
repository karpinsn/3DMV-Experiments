function [ holoFrame ] = holoEncode( depthMap, frequency )
%HOLOENCODE HoloEncodes the specified depthMap into a holoFrame
%   
%   Arguments:
%       depthMap - Depthmap with depth values ranging from 0 - 1
%
%   Returns:
%       holoFrame - Holo encoded frame with colors ranging from 0 - 1

%   Create a holoFrame to hold the results
[m, n] = size(depthMap);
holoFrame = zeros(m, n, 3);

% Figure out the step height, width, and frequency based off the frequency
stepHeight = 1 / frequency; 
stepWidth = 1 / frequency; 
stepFrequency = frequency * (4.0 + .5); 

% Calculate the k (phase jumps)
k = (floor(depthMap * frequency) * stepHeight); 

holoFrame(:,:,1) = (1.0 - sin(2*pi*frequency*depthMap)) * .5;
holoFrame(:,:,2) = (1.0 - cos(2*pi*frequency*depthMap)) * .5;
holoFrame(:,:,3) = cos(2*pi*stepFrequency * (depthMap - (k * (1/stepHeight) * stepWidth)) + pi) * (stepHeight / 3.0) + (stepHeight / 2.0) + k; 

end

