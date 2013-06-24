function [ fringe ] = GenNPhasePattern( n, pitch, width, height, direction)
%GEN3PHASEPATTERN Generates a packed set of 3 phase shifted patterns
%   
%   Arguments:
%       pitch - Pitch of the fringe. Number of pixels per period
%       width - Width of the fringe
%       height - Height of the fringe
%       direction - Direction of the fringe
%           0 - Corresponds to horizontal
%           1 - Corresponds to vertical

if (0 == direction)
    x = 1 : width;
else
    x = 1 : height;
end

fringe = zeros(height, width, n);

for pattern = 1 : n
    wave = (1.0 - cos((2.0 * pi) * (x / pitch) + ((2.0 * pi * (pattern - 1)) /n))) * .5;

    if(0 == direction)
        fringe(:,:,pattern) = ones(height, 1) * wave;
    else
        fringe(:,:,pattern) = wave' * ones(1, width);
    end
end

end

