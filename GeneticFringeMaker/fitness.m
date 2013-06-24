function [z, phaseDiff] = fitness(I)

global gaussianWidth H width height sourceName source pitch source1

I = reshape(I, height, width);
I = imfilter(I, H, 'circular');
phaseDiff = abs(I - source1);
z = (rms(I(:) - source1(:)));

end