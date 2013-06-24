%% Constants
pitch1 = 54;
pitch2 = 60;
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);
fringeCount = 6;

width = 800;
height = 600;

min = 158;
max = 257;

%% Phase Unwrapping Line
m = 2 * pi / pitch12;
b = (-pi * (max + min) ) / pitch12;
unwrappingLine = @(x) m * x + b;

%% Fringe loading
close1 = double(imread('Close/fringe1.png'));
close2 = double(imread('Close/fringe2.png'));

med1 = double(imread('Med/fringe1.png'));
med2 = double(imread('Med/fringe2.png'));

far1 = double(imread('Far/fringe1.png'));
far2 = double(imread('Far/fringe2.png'));

%% Wrapping
[c1, c2, c12] = fringe2phase( close1, close2 );
[m1, m2, m12] = fringe2phase( med1, med2 );
[f1, f2, f12] = fringe2phase( far1, far2 );

%% Plot
f12(200, 1:150) = 0;

figure;
hold on;
plot(c12(200, :), 'r');
plot(m12(200, :), 'g');
plot(f12(200, :), 'b');
plot(unwrappingLine(1:800), 'k');

%% Unwrapping
for w = 1 : width
    for h = 1 : height
        c12(h,w) = c12(h,w) + (c12(h,w) < unwrappingLine(w)) * 2 * pi;
        m12(h,w) = m12(h,w) + (m12(h,w) < unwrappingLine(w)) * 2 * pi;
        f12(h,w) = f12(h,w) + (f12(h,w) < unwrappingLine(w)) * 2 * pi;
    end
end

%% Test Plot
figure;
hold on;
plot(c12(200,:), 'r');
plot(m12(200,:), 'g');
plot(f12(200,:), 'b');

%% Unwrap phi1
kc = floor((c12 * (pitch12/pitch1) - c1) / (2.0 * pi));
km = floor((m12 * (pitch12/pitch1) - m1) / (2.0 * pi));
kf = floor((f12 * (pitch12/pitch1) - f1) / (2.0 * pi));

% This phase should be unwrapped
c = c1 + kc * 2.0 * pi;
m = m1 + km * 2.0 * pi;
f = f1 + kf * 2.0 * pi;

%% Test Plot
figure;
hold on;
plot(c(200,:), 'r');
plot(m(200,:), 'g');
plot(f(200,:), 'b');