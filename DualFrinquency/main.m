width = 1024;
height = 768;
pitch1 = 70;
pitch2 = 75;

x = 1 : width;

%% 3 Step - Generation
I = zeros(height, width, 4);
%I(:,:,1) = ones(height, 1) * ( 2.0 - cos((2.0 * pi) * (x/pitch1) + ((2.0 * pi) / 3)) + cos((2.0 * pi) * (x/1026) + ((2.0 * pi) / 3))) * .25;
I(:,:,1) = ones(height, 1) * ( 2.0 - cos((2.0 * pi) * (x/pitch1) - ((2.0 * pi) / 3)) + cos((2.0 * pi) * (x/pitch2) + ((2.0 * pi) / 3))) * .25;
I(:,:,2) = ones(height, 1) * ( 2.0 - cos((2.0 * pi) * (x/pitch1) + 0.0             ) + 0.0                                            ) * .25;
I(:,:,3) = ones(height, 1) * ( 2.0 - cos((2.0 * pi) * (x/pitch1) + ((2.0 * pi) / 3)) + cos((2.0 * pi) * (x/pitch2) - ((2.0 * pi) / 3))) * .25;
I(:,:,4) = ones(height, 1) * ( 2.0 - 0.0                                             + cos((2.0 * pi) * (x/pitch2) + 0.0             )) * .25;

plot(I(300,:,1))
%% 5 Step - Generation
N = 5;

I = zeros(height, width, N);
shift = 0;

for pattern = 1 : N
    B1 = (1.0 - cos((2.0 * pi) * (x / pitch1) + ((2.0 * pi * pattern) / N) + shift)) * .5 * .50;
    B2 = (1.0 - cos((2.0 * pi) * (x / pitch2) + ((4.0 * pi * pattern) / N) + shift)) * .5 * .50;
    wave = B1 + B2; 
    I(:,:,pattern) = ones(height, 1) * wave; 
end

dithered = stuckiDithering(I);

% Save our images
for pattern = 1 : N
    imwrite(dithered(:,:,pattern), sprintf('%d.png', pattern));
end

%% 5 - Step Testing
video = VideoReader('TestData\NoMotion-70_75.avi');
fringe = zeros(video.height, video.width, 5);
start = 8;
width = video.width;
height = video.height;

for c = 1 : N
    fringe(:,:,c) = rgb2gray(read(video, start+c));
end

phi1S = zeros(height, width);
phi1C = zeros(height, width);
phi2S = zeros(height, width);
phi2C = zeros(height, width);

for pattern = 1 : N 
    phi1S = phi1S + fringe(:,:,pattern) * sin((2 * pi * pattern / N));
    phi1C = phi1C + fringe(:,:,pattern) * cos((2 * pi * pattern / N));
    phi2S = phi2S + fringe(:,:,pattern) * sin((4 * pi * pattern / N));
    phi2C = phi2C + fringe(:,:,pattern) * cos((4 * pi * pattern / N));    
end

size = 7;
h = fspecial('gaussian', [size, size], size/3);
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);

close all;
figure;
phi1 = -atan2(phi1S, phi1C);
phi2 = -atan2(phi2S, phi2C);
phi12 = mod(phi1 - phi2, 2.0 * pi);
k = floor((phi12 * (pitch12/pitch1) - phi1) / (2.0 * pi));
phase = phi1 + k * 2.0 * pi;
subplot(2,4,1); imagesc(phi1);
subplot(2,4,2); imagesc(phi2);
subplot(2,4,3); imagesc(phi12);
subplot(2,4,4); imagesc(phase);

phi1F = -atan2(imfilter(phi1S,h), imfilter(phi1C,h));
phi2F = -atan2(imfilter(phi2S,h), imfilter(phi2C,h));
phi12F = mod(phi1F - phi2F, 2.0 * pi);
phi12F = imfilter(phi12F, h);
kf = (phi12F * (pitch12/pitch1) - phi1F) / (2.0 * pi);
magicGodDamnNumber = .26;

k = floor(kf - magicGodDamnNumber);

phase = phi1F + k * 2.0 * pi;
phase = medfilt2(phase, [5, 5]);

subplot(2,4,5); imagesc(phi1F);
subplot(2,4,6); imagesc(phi2F);
subplot(2,4,7); imagesc(phi12F);
subplot(2,4,8); imagesc(phase);
colormap gray;