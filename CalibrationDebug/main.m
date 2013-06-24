% Pitches of the patterns.
pitch1 = 70;
pitch2 = 75; 
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);
n = 5;

[height, width] = size(imread(sprintf('Captured/%d.png', 0)));
phi1S = zeros(height, width);
phi1C = zeros(height, width);

for channel = 0 : n - 1
    fringe1 = double(imread(sprintf('Captured/%d.png', channel)));
    fringe1 = fringe1 / 255.0;
    phi1S = phi1S + fringe1 * sin(2 * pi * channel / n);
    phi1C = phi1C + fringe1 * cos(2 * pi * channel / n);
end

phase = atan2(phi1S, phi1C);

imagesc(phase);
colormap gray;
colorbar;
