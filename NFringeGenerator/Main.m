%% User defined variables
% Width and height of the fringes
width = 1024;
height = 768;

% 0 - Horizontal
% 1 - Vertical
direction = 0;

% Number of patterns to generate
n = 3;

% Pitches of the patterns.
pitch1 = 60;
pitch2 = 63; 

%% Generate Ideal Patterns
fringe1 = GenNPhasePattern(n, pitch1, width, height, direction);
fringe2 = GenNPhasePattern(n, pitch2, width, height, direction);

%% Output generated patterns
for channel = 1 : n
    out = uint8(fringe1(:,:,channel) * 255.0);
    imwrite(out, sprintf('Patterns/%d-%d.png', pitch1, channel));

    out = uint8(fringe2(:,:,channel) * 255.0);
    imwrite(out, sprintf('Patterns/%d-%d.png', pitch2, channel));
end

%% Generate Ideal Patterns
direction = 1;
fringe1 = GenNPhasePattern(n, pitch1, width, height, direction);
fringe2 = GenNPhasePattern(n, pitch2, width, height, direction);

%% Output generated patterns
for channel = 1 : n
    out = uint8(fringe1(:,:,channel) * 255.0);
    imwrite(out, sprintf('Patterns/Vert%d-%d.png', pitch1, channel));

    out = uint8(fringe2(:,:,channel) * 255.0);
    imwrite(out, sprintf('Patterns/Vert%d-%d.png', pitch2, channel));
end

%% Test phase unwrapping
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);

phi1S = zeros(height, width);
phi2S = zeros(height, width);
phi1C = zeros(height, width);
phi2C = zeros(height, width);

for channel = 1 : n
    phi1S = phi1S + fringe1(:,:,channel) * sin(2 * pi * channel / n);
    phi1C = phi1C + fringe1(:,:,channel) * cos(2 * pi * channel / n);
    phi2S = phi2S + fringe2(:,:,channel) * sin(2 * pi * channel / n);
    phi2C = phi2C + fringe2(:,:,channel) * cos(2 * pi * channel / n);
end

phi1 = -atan2(phi1S, phi1C);
phi2 = -atan2(phi2S, phi2C);

phi12 = mod(phi1 - phi2, 2.0 * pi);

k = floor((phi12 * (pitch12/pitch1) - phi1) / (2.0 * pi));

% This phase should be unwrapped
phase = phi1 + k * 2.0 * pi;
