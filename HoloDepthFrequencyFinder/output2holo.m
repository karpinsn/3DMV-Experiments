function [ holo ] = output2holo( filename )
%OUTPUT2HOLO Reads in the specified filename and converts the image to a
%holoframe with values ranging from 0 - 1
%
%   Arugments:
%       filename - Filename of the file to read in
%
%   Returns:
%       holo - Holoframe with values ranging from 0 - 1
holotemp = imread(filename);
holo = double(holotemp);
holo = holo / 255.0;

end

