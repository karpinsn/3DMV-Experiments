clear;
H = 256.0;
W = 256.0;

x = linspace(-1.0, 1.0, W);


F = 4.0;                              % Frequency of the fringe (Needs to be even for Ib fringe)
angularFrequency = 2.0 * pi * F;      % Angular Frequency of the fringe (omega)
P = W / (2 * F);
theta = pi/6;

stepHeight = 1.0 / (2 * F);       % Make the step height as large as possible. 
stepWidth = 1.0 / F;

r = (1.0 - sin(angularFrequency * x)) * .5;
g = (1.0 - cos(angularFrequency * x)) * .5;
b = floor(x .* F) * stepHeight + .5;
Ib = cos((angularFrequency * 4.5) * (x - (b * (1.0 / stepHeight) * stepWidth)) + pi) * (stepHeight/2.5) + (stepHeight/2.0) + b;
Ib(1, W) = 1.0; % Cap it at 1.0

I = zeros(H, W, 3);
I(:, :, 1) = ones(H,1) * r;
I(:, :, 2) = ones(H,1) * g;
I(:, :, 3) = ones(H,1) * Ib;

% -------------------------------------------------------------------------
% Plot the results
% -------------------------------------------------------------------------
figure;

lineWidth = 4;
fontSize = 20;

clf;
imagesc(I); axis off;
set(gcf, 'Color', 'none'); % Sets figure background

imwrite(I, 'TestHolo1.png');