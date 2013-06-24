function [phase, gamma] = fringe2phase(fringe1, fringe2, fringe3, fringe1WaveNum, fringe2WaveNum, fringe3WaveNum)
%FRINGE2PHASE Calculates the phase map and gamma fringe the passed in fringes

phi1 = atan2(sqrt(3.0) * (fringe1(:,:,1)  - fringe1(:,:,3)), 2.0 * fringe1(:,:,2) - fringe1(:,:,1) - fringe1(:,:,3));
phi2 = atan2(sqrt(3.0) * (fringe2(:,:,1)  - fringe2(:,:,3)), 2.0 * fringe2(:,:,2) - fringe2(:,:,1) - fringe2(:,:,3));
phi3 = atan2(sqrt(3.0) * (fringe3(:,:,1)  - fringe3(:,:,3)), 2.0 * fringe3(:,:,2) - fringe3(:,:,1) - fringe3(:,:,3));

phi12 = -mod(phi2 - phi1, 2.0 * pi);
phi13 = -mod(phi3 - phi1, 2.0 * pi);

% Remove the phase jump
phi12 = atan2(sin(phi12), cos(phi12));

P12 = (fringe1WaveNum * fringe2WaveNum) / abs(fringe1WaveNum - fringe2WaveNum);
P13 = (fringe1WaveNum * fringe3WaveNum) / abs(fringe1WaveNum - fringe3WaveNum);

k13 = round((phi12 * (P12/P13) - phi13) / (2.0 * pi));
phase13 = phi13 + k13 * 2.0 * pi;

k = round((phase13 * (P13/fringe1WaveNum) - phi1) / (2.0 * pi));

gamma = sqrt((2 * fringe1(:,:,2) - fringe1(:,:,1) - fringe1(:,:,3))^2 + 3.0 * (fringe1(:,:,1) - fringe1(:,:,3))^2) / (fringe1(:,:,1) + fringe1(:,:,2) + fringe1(:,:,3));
phase = phi1 + k * 2.0 * pi;
end
