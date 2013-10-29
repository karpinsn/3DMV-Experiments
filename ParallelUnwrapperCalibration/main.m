%% Constants
clear;
width = 800;
height = 600;
pitch1 = 54;
pitch2 = 60;
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2); 

%% Data loading
near1 = double(imread('Near/fringe1.png'));
near2 = double(imread('Near/fringe2.png'));

far1 = double(imread('Far/fringe1.png'));
far2 = double(imread('Far/fringe2.png'));

[n1, n2, n12] = fringe2phase( near1, near2 );
[f1, f2, f12] = fringe2phase( far1, far2 );

%% Point detection
close all;
figure;
hold on;
plot(n12(height/2, :), 'r');
plot(f12(height/2, :), 'b');

pitch12Cam = 570;
%P1
P2 = 180;
P3 = 300;
%P4
% Unwrapping data calculation
m = (2 * pi) / pitch12Cam;
b = (-pi * (P2 + P3) ) / pitch12Cam;

unwrappingLine = @(x) m * x + b;

%% Unwrapping line verification
close all;
figure;
hold on;
plot(n12(height/2, :), 'r');
plot(f12(height/2, :), 'b');
plot(unwrappingLine(1:width), 'k');

%% Actual images
ParallelUnwrapper(near1, near2, far1, far2, pitch1, pitch2, unwrappingLine);