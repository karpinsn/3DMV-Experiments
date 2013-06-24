video = VideoReader('Ref.avi');

vidHeight = video.Height;
vidWidth = video.Width;

% Preallocate movie structure.
mov(1:3) = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),'colormap', []);

% Read one frame at a time.
for k = 1 : 9
    mov(k).cdata = read(video, k);
end

frame = zeros(vidHeight, vidWidth, 3);
frame = uint8(frame);

frame(:,:,1) = rgb2gray(mov(1).cdata);
frame(:,:,2) = rgb2gray(mov(2).cdata);
frame(:,:,3) = rgb2gray(mov(3).cdata);
imwrite(frame, 'Small.png');

frame(:,:,1) = rgb2gray(mov(4).cdata);
frame(:,:,2) = rgb2gray(mov(5).cdata);
frame(:,:,3) = rgb2gray(mov(6).cdata);
imwrite(frame, 'Med.png');

frame(:,:,1) = rgb2gray(mov(7).cdata);
frame(:,:,2) = rgb2gray(mov(8).cdata);
frame(:,:,3) = rgb2gray(mov(9).cdata);
imwrite(frame, 'Large.png');