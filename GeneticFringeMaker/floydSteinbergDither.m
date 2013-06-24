function [ditheredImage] = floydSteinbergDither(image)
%FLOYDSTEINBERGDITHER Ditheres the specified image with the Floyd Steinberg
% error diffusing technique
%      
%   Arguments:
%       image - Image to dither
%
%   Returns:
%       ditheredImage - Resulting dithered image

[m, n, c] = size(image);

% Perform the actual dithering
ditheredImage = image;
for channel = 1 : c
    for row = 1 : m
        for col = 1 : n
            oldPixel = ditheredImage(row,col,channel);
            newPixel = round(oldPixel); % Will give us either 0 or 1
            ditheredImage(row,col,channel) = newPixel;
            error = oldPixel - newPixel;
            
            % Diffuse error
            if col < n
                ditheredImage(row,col+1,channel) = ditheredImage(row,col+1,channel) + (7/16 * error);
            end
            
            if col > 1 && row < m
                ditheredImage(row+1,col-1,channel) = ditheredImage(row+1,col-1,channel) + (3/16 * error);
            end
            
            if row < m
                ditheredImage(row+1,col,channel) = ditheredImage(row+1,col,channel) + (5/16 * error);
            end
            
            if row < m && col < n
                ditheredImage(row+1,col+1,channel) = ditheredImage(row+1,col+1,channel) + (1/16 * error);
            end
        end
    end
end