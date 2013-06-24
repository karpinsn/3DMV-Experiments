function [ filteredPhase ] = phaseMedFilter( phase, size)
%PHASEMEDFILTER Runs a median filter on the phase but instead of replacing
% with the median it calculates the correct number of phase jumps and uses
% that value instead
%
% phase - Phasemap to filter
% size - Size of the median filter to use

tolerance = .1;

medPhase = medfilt2(phase, [size size]);
phaseJump = (medPhase - phase) / (2.0 * pi);

phaseJump(phaseJump < -tolerance) = phaseJump(phaseJump < -tolerance) - .5;
phaseJump(phaseJump > tolerance) = phaseJump(phaseJump > tolerance) + .5;
phaseJump = int8(phaseJump);
phaseJump = double(phaseJump);

% Use the calculated phase jump to adjust the phase 
filteredPhase = phase + (phaseJump * 2.0 * pi);

end