function writexyzm(filename, xyz, rgb, validFlags, width, height)
%WRITEXYZM Summary of this function goes here
%   Detailed explanation goes here

% Open the file for reading
fileHandle = fopen(filename, 'w');

% Create the header for the XYZM file
header = sprintf('image size width x height = %d x %d', width, height);

% Create the vertex stream to go into the file
%vertexStream = zeros(width * height * 3);
vertexStream(1 : 3 : width * height * 3) = reshape(xyz(:, :, 1), 1, width * height);
vertexStream(2 : 3 : width * height * 3) = reshape(xyz(:, :, 2), 1, width * height);
vertexStream(3 : 3 : width * height * 3) = reshape(xyz(:, :, 3), 1, width * height);

% Create the texture stream to go into the file
%textureStream = zeros(width * height * 3);
textureStream(1 : 3 : width * height * 3) = reshape(rgb(:, :, 1), 1, width * height);
textureStream(2 : 3 : width * height * 3) = reshape(rgb(:, :, 2), 1, width * height);
textureStream(3 : 3 : width * height * 3) = reshape(rgb(:, :, 3), 1, width * height);

% Create the valid flag stream to go into the file
validStream = reshape(validFlags, 1, width * height);

% Write the streams out to the file
fwrite(fileHandle, header);
fwrite(fileHandle, vertexStream, 'float32');
fwrite(fileHandle, textureStream, 'uchar'); 
fwrite(fileHandle, validStream, 'uchar');

% Close out the file
fclose(fileHandle);

end

