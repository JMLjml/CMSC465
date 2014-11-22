%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw4b.m
% November 20, 2014
%
% This script reads in an image and then rezies it to 1.5x, 2.0x, and 3.0x its original
% size using a nearest, bilinear, and bicubic algorithm to comare the results. The 
% resulting images are plotted for comparrison.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% load the image package tools
pkg load image;

% load our test image into octave
test_image = imread("guitar.jpg");

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function plot_resizes(test_image, figure_count, scale)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        plot_resizes(test_image, figure_count, scale)
%
%        Helper function that plots the various resize of the orignial image.
%        It plots the nearest, bilinear and bicubic resizes of the oringial image.
%
%        test_image: image under investigation
%        figure_count: integer used to lavel the figure windows
%        scale: How much to resize the image. Valid sizes are 1.5, 2.0 and 3.0
%        
%        Author: John Lasheski
function plot_resizes(test_image, figure_count, scale)
  
  % just some formating for the titles of the plots
  if scale == 1.5
    scale_label = " 1.5 Times ";
  elseif scale == 2.0
    scale_label = " 2.0 Times ";
  elseif scale == 3.0
    scale_label = " 3.0 Times ";
  end

  % create the rescaled images
  test_image_nearest = imresize(test_image, scale, 'nearest');
  test_image_bilinear = imresize(test_image, scale, 'bilinear');
  test_image_bicubic = imresize(test_image, scale, 'bicubic');

    % display the scaled image using Nearest
  figure(figure_count);
  imshow(test_image_nearest);
  label = strcat("Image Scaled to", scale_label, " Using Nearest");  
  set(gca, 'title', label);

  % display the scaled image using Biliear
  figure(figure_count + 1);
  imshow(test_image_bilinear);
  label = strcat("Image Scaled to", scale_label, " Using Bilinear");  
  set(gca, 'title', label);

  % display the scaled image using Bicubic
  figure(figure_count + 2);
  imshow(test_image_bicubic);
  label = strcat("Image Scaled to", scale_label, " Using Bicubic");  
  set(gca, 'title', label);
end


% plot the original image
figure(1);
imshow(test_image);
set(gca, 'title', 'Orginal Image');

% plot the rescaled images
plot_resizes(test_image, 2, 1.5);
plot_resizes(test_image, 5, 2.0);
plot_resizes(test_image, 8, 3.0);

