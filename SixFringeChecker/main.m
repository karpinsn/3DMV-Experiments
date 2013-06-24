%% Constants
pitch1 = 60;
pitch2 = 63;

%% Fringe loading
video = VideoReader('Motion-60_63.avi');
width = video.width;
height = video.height;

fringe1 = zeros(height, width, 0);
fringe2 = zeros(height, width, 0);
%fringe1 = double(imread('Phi0.png'));
%fringe2 = double(imread('Phi1.png'));
start = 0;

fringe1(:,:,1) = rgb2gray(read(video, start + 1));
fringe2(:,:,1) = rgb2gray(read(video, start + 2));
fringe1(:,:,2) = rgb2gray(read(video, start + 3));
fringe2(:,:,2) = rgb2gray(read(video, start + 4));
fringe1(:,:,3) = rgb2gray(read(video, start + 5));
fringe2(:,:,3) = rgb2gray(read(video, start + 6));

%% Unwrapping
difference = abs(fringe1 - fringe2);

phase = fringe2phase(fringe1, fringe2, pitch1, pitch2);

%% 2+1 -ish

x = 1 : 1024;
pitch = 63;

Icos = cos((2.0 * pi) * (x / pitch));
Isin = sin((2.0 * pi) * (x / pitch));

%plot(atan2(Isin, Icos));

figure;
hold on;
plot(Icos, 'b');
plot(acos(Icos), 'r');