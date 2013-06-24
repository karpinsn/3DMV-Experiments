function [ phaseMap ] = fringe2phase(fringe1, fringe2, pitch1, pitch2)

% Calculate the pitches
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);

% Wrap the phase
phi1 = atan2((sqrt(3.0) .* (fringe1(:,:,1) - fringe1(:,:,3))), (2.0 .* fringe1(:,:,2)) - fringe1(:,:,1) - fringe1(:,:,3));
phi2 = atan2((sqrt(3.0) .* (fringe2(:,:,1) - fringe2(:,:,3))), (2.0 .* fringe2(:,:,2)) - fringe2(:,:,1) - fringe2(:,:,3));

h = fspecial('gaussian', [7 7], 7/3);
phi1C = imfilter(cos(phi1), h);
phi1S = imfilter(sin(phi1), h);
phi2C = imfilter(cos(phi2), h);
phi2S = imfilter(sin(phi2), h);
%phi1C = phaseMedFilter(cos(phi1), 5);
%phi1S = phaseMedFilter(sin(phi1), 5);
%phi2C = phaseMedFilter(cos(phi2), 5);
%phi2S = phaseMedFilter(sin(phi2), 5);


phi1 = atan2(phi1S, phi1C);
phi2 = atan2(phi2S, phi2C);

% Calculate equivalent wavelengths
phi12 = mod(phi1 - phi2, 2.0 * pi);
gamma1 = sqrt( ( 2 .* fringe1(:,:,2) - fringe1(:,:,1) - fringe1(:,:,3) ).^2 + ...
    3 .* ( fringe1(:,:,1) - fringe1(:,:,3) ).^2 ) ./ (fringe1(:,:,1) + fringe1(:,:,2) + fringe1(:,:,3));

gamma2 = sqrt( ( 2 .* fringe2(:,:,2) - fringe2(:,:,1) - fringe2(:,:,3) ).^2 + ...
    3 .* ( fringe2(:,:,1) - fringe2(:,:,3) ).^2 ) ./ (fringe2(:,:,1) + fringe2(:,:,2) + fringe2(:,:,3));
gamma = min(gamma1, gamma2);

gammaLevel = .10;
mask = gamma > gammaLevel;

% Gamma Filter values off
%phi12M = phi12;
%phi12M(~mask) = NaN;
%phi12F = phaseMedFilter(phi12M, 5); 

%phi12C = imfilter(cos(phi12), h);
%phi12S = imfilter(cos(phi12), h);
phi12 = imfilter(phi12, h);

% Better way
kd = (phi12 * (pitch12/pitch1) - phi1) / (2.0 * pi);

kc = ceil(kd);
kr = round(kd);
kf = floor(kd);

% This phase should be unwrapped
phaseMap = phi1 + k * 2.0 * pi;
phaseMap(~mask) = NaN;

end
