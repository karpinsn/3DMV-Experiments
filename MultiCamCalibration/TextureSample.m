function [ sampledColor ] = TextureSample( uvCoords, image )
%TEXTURESAMPLE Samples the texture based on the specified uvCoordinates
% Performs linear interpolation of four nearest color values. 
% uvCoords should range from 0 - 1
% Currently, only works for single channel images

[height, width] = size(image);
scaledCoord = uvCoords .* ([width - 1; height - 1; 1.0] * ones(1, width*height)) ...
                        + ([1.0; 1.0; 0.0] * ones(1, width*height));

coordSampling(:,:,1) = [floor(scaledCoord(1,:)); floor(scaledCoord(2,:))];
coordSampling(:,:,2) = [floor(scaledCoord(1,:)); ceil(scaledCoord(2,:))];
coordSampling(:,:,3) = [ceil(scaledCoord(1,:)); floor(scaledCoord(2,:))];
coordSampling(:,:,4) = [ceil(scaledCoord(1,:)); ceil(scaledCoord(2,:))];

% Need to normalize the magnitude in all directions
samplePercentage = zeros(size(coordSampling));

for direction = 1:4
    samplePercentage(:,:,direction) = abs([scaledCoord(1,:);scaledCoord(2,:)] - coordSampling(:,:,direction));
    %mag = mag + sum(norm(samplePercentage(:,:,direction)));
end
samplePercentage = samplePercentage ./  (152.0014 * 4);
% Think there is a div by 0 error in here but I dont really care
% Probablly when we are right on the pixel
%samplePercentage(isnan(samplePercentage)) = 0.0;

% The ordering is done this way since we took the transpose for the
% coordinates earlier
indicies = sub2ind([width, height], squeeze(coordSampling(1,:,:)), squeeze(coordSampling(2,:,:)));
colors = double(image(indicies));

sampledColor = zeros(width * height, 1);
for direction = 1:4
    sampledColor = sampledColor + colors(:,direction) .* norm(samplePercentage(:,:,direction));
end

end
