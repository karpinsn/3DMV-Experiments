fringe1(:,:,1) = rgb2gray(imread('fc2_save_2013-06-17-105348-0004.png'));
fringe1(:,:,2) = rgb2gray(imread('fc2_save_2013-06-17-105348-0005.png'));
fringe1(:,:,3) = rgb2gray(imread('fc2_save_2013-06-17-105348-0006.png'));

fringe2(:,:,1) = rgb2gray(imread('fc2_save_2013-06-17-105348-0001.png'));
fringe2(:,:,2) = rgb2gray(imread('fc2_save_2013-06-17-105348-0002.png'));
fringe2(:,:,3) = rgb2gray(imread('fc2_save_2013-06-17-105348-0003.png'));

imwrite(fringe1, 'fringe1.png');
imwrite(fringe2, 'fringe2.png');