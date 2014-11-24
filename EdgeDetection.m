%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% EdgeDetection.m
% November 24, 2014
%
% Octave script file that explores the Sobel, Prewitt, Roberts and Kirsch methods of 
% edge detection on an image. sample image is explored and plots are created to view the 
% differences in the methods.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% load the image package tools
pkg load image;

% load our test image into octave
test_image = imread("owl.jpg");

% perform edge detection using four diferrent techniques
bw_sobel = edge(test_image, 'sobel');
bw_prewitt = edge(test_image, 'prewitt');
bw_roberts = edge(test_image, 'roberts');
bw_kirsch = edge(test_image, 'kirsch');

% display the results
figure(1);
hold on;

subplot(151);
imshow(test_image);
set(gca, 'title', 'Original Image');

subplot(152);
imshow(bw_sobel);
set(gca, 'title', 'Edge Detection using Sobel Method');

subplot(153);
imshow(bw_prewitt);
set(gca, 'title', 'Edge Detection using Prewitt Method');

subplot(154);
imshow(bw_roberts);
set(gca, 'title', 'Edge Detection using Roberts Method');

subplot(155);
imshow(bw_kirsch);
set(gca, 'title', 'Edge Detection using Kirsch Method');
hold off;
