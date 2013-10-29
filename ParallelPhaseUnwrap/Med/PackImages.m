start = 1;

fileSpec = 'fc2_save_2013-07-05-092002-000%d.png';

fringe1(:,:,1) = rgb2gray(imread(sprintf(fileSpec, start))); start = mod(start + 1, 6);
fringe1(:,:,2) = rgb2gray(imread(sprintf(fileSpec, start))); start = mod(start + 1, 6);
fringe1(:,:,3) = rgb2gray(imread(sprintf(fileSpec, start))); start = mod(start + 1, 6);

fringe2(:,:,1) = rgb2gray(imread(sprintf(fileSpec, start))); start = mod(start + 1, 6);
fringe2(:,:,2) = rgb2gray(imread(sprintf(fileSpec, start))); start = mod(start + 1, 6);
fringe2(:,:,3) = rgb2gray(imread(sprintf(fileSpec, start))); start = mod(start + 1, 6);

imwrite(fringe1, 'fringe1.png');
imwrite(fringe2, 'fringe2.png');