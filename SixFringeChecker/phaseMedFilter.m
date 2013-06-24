function [ filteredPhase ] = phaseMedFilter( phase, filterSize)
%PHASEMEDFILTER Runs a modified median filter on the phase
%
% phase - Phasemap to filter
% size - Size of the median filter to use

window = (filterSize - 1) / 2;
filteredPhase = phase;
mask = ~isnan(phase);

for c = window + 1 : size(phase, 2) - window
    % Use NaN median so that we dont shrink our image
    med = nanmedian(filteredPhase(:,c-window:c+window), 2);
    filteredPhase(:,c) = med;
end

% We will just need to reapply the mask to get our NaNs back
filteredPhase(~mask) = NaN;

end