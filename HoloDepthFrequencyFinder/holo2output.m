function holo2output( holo, filename )
%HOLO2IMAGE Quantizes the holoimage into image values (0 - 255) then writes
% it out to an image
%
%   Arguments:
%       holo - Holoimage with colors ranging from 0 - 1
%       filename - Filename of the image to save to

holoTemp = holo * 255.0;
holoTemp = uint8(holoTemp);

imwrite(holoTemp, filename);

end

