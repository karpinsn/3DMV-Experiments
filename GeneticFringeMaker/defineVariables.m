function defineVariables(pitchLocal)


global gaussianWidth H width height sourceName source lastBest pitch source1

pitch = pitchLocal;
gaussianWidth = 7;

H = fspecial('gaussian', [gaussianWidth gaussianWidth], gaussianWidth/3);
if nargin == 0,
    sourceName = 'images/sin_w_third.png';
    source1 = im2double(imread(sourceName));
else,
    width = pitch;
    height = 24;
    X = meshgrid(1:pitch, 1:height);
    source1 = 0.5*(1 + sin(X*2*pi/pitch));
end


[height width x] = size(source1);
source = source1(:,:,1);
lastBest = source;
source = reshape(source, 1, []);




end