function [ clampedCoords ] = ClampTextureCoordinates( texCoords )
%CLAMPTEXTURECOORDINATES Clamps the texture coordinates to be in the range
% of 0.0 - 1.0

clampedCoords = texCoords;
clampedCoords(clampedCoords > 1.0) = 1.0;
clampedCoords(clampedCoords < 0.0) = 0.0;

end

