function [ phaseMap ] = fringe2phase(fringe1, fringe2, pitch1, pitch2)

tolerance = .01;

% Calculate the pitches
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);

% Wrap the phase
phi1 = atan2((sqrt(3.0) .* (fringe1(:,:,1) - fringe1(:,:,3))), (2.0 .* fringe1(:,:,2)) - fringe1(:,:,1) - fringe1(:,:,3));
phi2 = atan2((sqrt(3.0) .* (fringe2(:,:,1) - fringe2(:,:,3))), (2.0 .* fringe2(:,:,2)) - fringe2(:,:,1) - fringe2(:,:,3));

% Calculate equivalent wavelengths
phi12 = mod(phi1 - phi2, 2.0 * pi);
gamma1 = sqrt( ( 2 .* fringe1(:,:,2) - fringe1(:,:,1) - fringe1(:,:,3) ).^2 + ...
    3 .* ( fringe1(:,:,1) - fringe1(:,:,3) ).^2 ) ./ (fringe1(:,:,1) + fringe1(:,:,2) + fringe1(:,:,3));

gamma2 = sqrt( ( 2 .* fringe2(:,:,2) - fringe2(:,:,1) - fringe2(:,:,3) ).^2 + ...
    3 .* ( fringe2(:,:,1) - fringe2(:,:,3) ).^2 ) ./ (fringe2(:,:,1) + fringe2(:,:,2) + fringe2(:,:,3));

gammaLevel = .15;
mask1 = gamma1 > gammaLevel;
mask2 = gamma2 > gammaLevel;
mask = mask1 & mask2;

% Gamma Filter values off
phi12M = phi12;
phi12M(~mask) = NaN;
phi12F = phaseMedFilter(phi12M, 7); 
phi12F = phaseMedFilter(phi12F, 7); 
h = fspecial('gaussian', 3, .3);
%phi12F = imfilter(phi12F, h);

% Unwrap
% Oldway
%k = round(((phi12 * (pitch12/pitch1) - phi1) - tolerance) / (2.0 * pi));
% Better way
%k = floor((phi12M * (pitch12/pitch1) - phi1) / (2.0 * pi));
kF = floor((phi12F * (pitch12/pitch1) - phi1) / (2.0 * pi));

% This phase should be unwrapped
%phaseMap = phi1 + k * 2.0 * pi;
phaseMap = phi1 + kF * 2.0 * pi;

end
