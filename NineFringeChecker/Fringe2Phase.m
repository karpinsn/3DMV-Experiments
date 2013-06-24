function [ phaseMap ] = fringe2Phase(fringe1, fringe2, fringe3, pitch1, pitch2, pitch3)

% Calculate the pitches
pitch12 = (pitch1 * pitch2) / abs(pitch1 - pitch2);
pitch13 = (pitch1 * pitch3) / abs(pitch1 - pitch3);
pitch123 = (pitch12 * pitch13) / abs(pitch12 - pitch13);

% Wrap the phase
phi1 = atan2((sqrt(3.0) .* (fringe1(:,:,1) - fringe1(:,:,3))), (2.0 .* fringe1(:,:,2)) - fringe1(:,:,1) - fringe1(:,:,3));
phi2 = atan2((sqrt(3.0) .* (fringe2(:,:,1) - fringe2(:,:,3))), (2.0 .* fringe2(:,:,2)) - fringe2(:,:,1) - fringe2(:,:,3));
phi3 = atan2((sqrt(3.0) .* (fringe3(:,:,1) - fringe3(:,:,3))), (2.0 .* fringe3(:,:,2)) - fringe3(:,:,1) - fringe3(:,:,3));

% Calculate equivalent wavelengths
phi12 = mod(phi1 - phi2, 2.0 * pi);
phi13 = mod(phi1 - phi3, 2.0 * pi);
phi123 = mod(phi12 - phi13, 2.0 * pi);

% Unwrap from largest to smalles
k13 = round( ( phi123 * ( pitch123 / pitch13 ) - phi13 ) / (2.0 * pi));
phase13 = phi13 + k13 * 2.0 * pi;

shift = .4; % Figure out why we have a shift
k3 = round( ( ( phase13 * ( pitch13 / pitch3 ) - phi3 ) / (2.0 * pi) ) - shift);
phase3 = phi3 + k3 * 2.0 * pi;

k = round( ( phase3 * ( pitch3 / pitch1 ) - phi1 ) / ( 2.0 * pi ) );
% This phase should be unwrapped
phaseMap = phi1 + k * 2.0 * pi;

end
