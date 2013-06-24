fringe1 = imread('Short.png');
fringe2 = imread('Med.png');
fringe3 = imread('Long.png');

% Make the images floating point images
fringe1 = double(fringe1);
fringe2 = double(fringe2);
fringe3 = double(fringe3);

% Adjust the range to 0 - 1
fringe1 = fringe1 / 255.0;
fringe2 = fringe2 / 255.0;
fringe3 = fringe3 / 255.0;

[phase, gamma] = fringe2phase(fringe1, fringe2, fringe3, 90, 102, 135);
