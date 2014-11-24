%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% EdgeDetection.m
% November 24, 2014
%
% Octave script file that explores the nearest, bilinear and bicubic methods of 
% translating, rotating, and shearing an image. sample image is explored and 
% plots are created to view the differences in the methods.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use Octave's edge methods to perform edge detection on an image of your choice (bw = edge (im, method, arg1, arg2). 
% Show the original image, your Octave code, and the edge extraction results for at least 4 different algorithms of 
% your choice. Which one seems to perform the best on your image? Compare and contrast the edge detection results 
% indicating strengths and weaknesses you observed.

clear all;

% load the image package tools
pkg load image;

% load our test image into octave
test_image = imread("owl.jpg");

