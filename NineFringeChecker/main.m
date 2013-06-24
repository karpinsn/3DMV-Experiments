pitch1 = 60;
pitch2 = 96;
pitch3 = 90;

%% Calculate the reference phase

% Generate some smooth reference phase
referenceAVI = VideoReader('Reference2.avi');
fringe1 = zeros(referenceAVI.Height, referenceAVI.Width, 3);
fringe2 = zeros(referenceAVI.Height, referenceAVI.Width, 3);
fringe3 = zeros(referenceAVI.Height, referenceAVI.Width, 3);
referencePhase = zeros(referenceAVI.Height, referenceAVI.Width);

for index = 0 : ((referenceAVI.NumberOfFrames / 9) - 9)
    for channel = 1 : 3
        fringe1(:,:,channel) = rgb2gray( read( referenceAVI, (index * 9) + channel) );
        fringe2(:,:,channel) = rgb2gray( read( referenceAVI, (index * 9 + 3) + channel) );
        fringe3(:,:,channel) = rgb2gray( read( referenceAVI, (index * 9 + 6) + channel) );
    end
    
    ref = fringe2phase(fringe1, fringe2, fringe3, pitch1, pitch2, pitch3);
    
    % Rolling average the phase to smooth it out
    referencePhase = (referencePhase * index + ref) / ( index + 1 );
end

%% Now decode the frames
videoObj = VideoReader('Capture1.avi');
colorRange = [2 12];

for index = 0 : ( ( videoObj.NumberOfFrames / 9 ) - 9 )
    for channel = 1 : 3
        fringe1(:,:,channel) = rgb2gray( read( videoObj, (index * 9) + channel) );
        fringe2(:,:,channel) = rgb2gray( read( videoObj, (index * 9 + 3) + channel) );
        fringe3(:,:,channel) = rgb2gray( read( videoObj, (index * 9 + 6) + channel) );
    end
    
    phase = fringe2phase(fringe1, fringe2, fringe3, pitch1, pitch2, pitch3);
    depth = phase2depth(phase, referencePhase, .5);
    
    imagesc(depth);
    colorbar;
    caxis(colorRange);
    colormap gray;
    drawnow
end