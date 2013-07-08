function [x ,y, z, r, g, b, m, w, h] = readxyzm(filename)
%READXYZM Reads in an XYZM file
%   Reads in an xyzm file
%   
%   Arguments:
%       filename - Filename of the XYZM to load
%
%   Returns:
%       x - 2D matrix of the x coordinates
%       y - 2D matrix of the y coordinates
%       z - 2D matrix of the z coordinates

% Open the file for reading
fid = fopen(filename, 'r');

% Read in the header of the file
A = fscanf(fid, 'image size width x height = %d x %d');
w = A(1);
h = A(2);

% XYZ coordinates
xyz = fread(fid, w * h * 3, 'float32');
% Texture
t = fread(fid, w * h * 3, 'uchar'); 
% Valid flags
m = fread(fid, w * h, 'uchar');

% Close out the file
fclose(fid);

% Reshape the valid flats to the proper width and height
m = reshape(m, w, h);

% Reshape the XYZ coordinates to the proper width and height
x = xyz(1 : 3 : w*h*3); 
y = xyz(2 : 3 : w*h*3); 
z = xyz(3 : 3 : w*h*3); 
x = reshape(x, w, h);
y = reshape(y, w, h);
z = reshape(z, w, h);

% Reshape the texture stream to the proper width and height
r = t(1 : 3 : w*h*3); 
g = t(2 : 3 : w*h*3); 
b = t(3 : 3 : w*h*3);
r = reshape(r, w, h);
g = reshape(g, w, h);
b = reshape(b, w, h);