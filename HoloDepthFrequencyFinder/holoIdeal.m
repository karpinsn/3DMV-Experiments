function [ holo ] = holoIdeal( frequency ) 
%HOLOIDEAL Generates the ideal Holopattern with an increasing depth 

z = linspace(0, 1, 512); 
depthMap = ones(512, 1) * z;

holo = holoEncode(depthMap, frequency);

% Since we are at the min and max we might go past the boundary. 
% Make sure to cap it so that we can display as a true color image
holo(holo > 1) = 1.0;
holo(holo < 0) = 0.0;

end 