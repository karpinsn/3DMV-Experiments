%% Globals
clear;
frequencyCount = 60;
MSE = ones(frequencyCount, 3);

%%  Experiment 1 - Simple angled plane
z = linspace(0, 1, 512); 
depthMap = ones(512, 1) * z;
% Just use all the points for the plane since they should be valid
mask = ones(512, 512);          

for frequency = 1:frequencyCount
    MSE(frequency, 1) = processShape(depthMap, mask, frequency);
    fprintf('Frequency: %1f \t MSE: %3.6f\n', frequency, MSE(frequency, 1));
end

%% Experiment 2 - Simple sphere
depthMap = zeros(512, 512);
mask = ones(512, 512);

for x = linspace(1, 512, 512)
    for y = linspace(1, 512, 512)
        depthMap(y, x) = sqrt(256^2 - ((x - 256)^2 + (y - 256)^2));
    end
end

depthMap = real(depthMap);
depthMap = depthMap / 256.0;
mask(0 == depthMap) = 0;

for frequency = 1:frequencyCount
    MSE(frequency, 2) = processShape(depthMap, mask, frequency);
    fprintf('Frequency: %1f \t MSE: %3.6f\n', frequency, MSE(frequency, 2));
end

%% Experiment 3 - Sample scan
[~ ,~, depthMap, ~, ~, ~, mask, ~, ~] = readxyzm('David.xyzm');
% Make sure the mask only contains 0 or 1
mask(mask > 0) = 1;

% Make sure the depthMap ranges from 0 - 1
depthMap(0 == mask) = NaN;
depthMap = depthMap - min(min(depthMap));
depthMap = depthMap / max(max(depthMap));
depthMap(isnan(depthMap)) = 0;


for frequency = 1:frequencyCount
    MSE(frequency, 3) = processShape(depthMap, mask, frequency);
    fprintf('Frequency: %1f \t MSE: %3.6f\n', frequency, MSE(frequency, 3));
end

%% Plot MSEs
figure;
hold on;
plot(MSE(:,1), 'r');
plot(MSE(:,2), 'g');
plot(MSE(:,3), 'b');