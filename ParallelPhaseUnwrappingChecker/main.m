%% Constants
pitch1 = 54;
pitch2 = 60;
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);
fringeCount = 6;

width = 800;
height = 600;

min = .35749999;
max = .64375001;
pitch12Cam = .33000001;

%% Read gDebuggerData
components = gDebuggerReadCSV('Components.csv', 800, 600, '%f');
% Not sure why it is backwards, dont really care
phi2 = atan2(components(:,:,1), components(:,:,2));
phi1 = atan2(components(:,:,3), components(:,:,4));

phi12 = mod( phi1 - phi2, 2 * pi );

%% Phase Unwrapping Line
m = (2 * pi) / pitch12Cam;
b = (-pi * (max - pitch12Cam + min) ) / pitch12Cam;
unwrappingLine = @(x) m * x + b;

%% Plot
figure;
hold on;
plot(unwrappingLine(linspace(0, 1, width) ), 'k');
plot(phi12(200, :), 'r');

%% Unwrapping
for w = 1 : width
    for h = 1 : height
        phi12(h,w) = phi12(h,w) + (phi12(h,w) < unwrappingLine((w / width))) * 2 * pi;
    end
end

plot(phi12(200, :), 'b');

%% Unwrap phi1
k = floor((phi12 * (pitch12/pitch1) - phi1) / (2.0 * pi));

% This phase should be unwrapped
phase = phi1 + k * 2.0 * pi;

%% Test Plot
figure;
hold on;
plot(phase(200,:), 'r');
plot(phi12(200,:), 'b');
