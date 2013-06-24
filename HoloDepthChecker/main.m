%% Actual Decode
frame = imread('Holo.png');

continuous = double(frame);
continuous = continuous / 255.0;

phaseMap = holo2phase(continuous, 16);
%phaseMap = phaseMedFilter(phaseMap, 7);
%phaseMap = phaseMedFilter(phaseMap, 7);
filt = fspecial('gaussian', [5 5], 5/3);
phaseMapFiltered = imfilter(phaseMap, filt, 'conv');

depthMap = phase2depth(phaseMap, 16);
depthFiltered = phase2depth(phaseMapFiltered, 16);
mesh(depthMap);

frameTotal = continuous(:,:,1) + continuous(:,:,2) + continuous(:,:,3); 
gamma1 = sqrt((2*(continuous(:,:,1)-continuous(:,:,2)).^2) ./ (continuous(:,:,1) + continuous(:,:,2)));