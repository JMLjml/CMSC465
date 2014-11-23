%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw4c.m
% November 20, 2014
%
% Octave script file that explores the nearest, bilinear and bicubic methods of 
% translating, rotating, and shearing an image. sample image is explored and 
% plots are created to view the differences in the methods.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% load the image package tools
pkg load image;

% load our test image into octave
test_image = imread("number-13.png");

% convert the image to a binary image
binary_image = im2bw(test_image);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function plot_translations(binary_image, figure_count, x, y)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        plot_rotations(binary_image, figure_count, x, y)
%
%        Helper function that plots the various translations of the original image.
%        It plots the nearest, bilinear and bicubic translations of the oringial image.
%
%        binary_image: image under investigation in binary format
%        figure_count: integer used to label the figure windows
%        x: How much to move the image on the x axis
%        y: How much to move the image on the y axis
%        
%        Author: John Lasheski
function plot_translations(binary_image, figure_count, x, y)
   
  % create the translated images
  test_image_nearest = imtranslate(binary_image, x, y, 'nearest', 'wrap');
  test_image_bilinear = imtranslate(binary_image, x, y, 'bilinear', 'wrap');
  test_image_bicubic = imtranslate(binary_image, x, y, 'bicubic', 'wrap');
  
  % create a figure to compare the results
  figure(figure_count)
  hold on;
 
  % plot the original image
  subplot(221)
  imshow(binary_image);
  set(gca, 'title', 'Original Image');
  
  % display the translated image using Nearest
  subplot(222);
  imshow(test_image_nearest);
  label = strcat("Image translated (x, y) = (", int2str(x),", ",  int2str(y), ") Using Nearest");  
  set(gca, 'title', label);

  % display the translated image using Bilinear
  subplot(223);
  imshow(test_image_bilinear);
  label = strcat("Image translated (x, y) = (", int2str(x),", ", int2str(y), ") Using Bilinear");
  set(gca, 'title', label);

  % display the translated image using Bicubic
  subplot(224);
  imshow(test_image_bicubic);
  label = strcat("Image translated (x, y) = (", int2str(x), ", ", int2str(y), ") Using Bicubic");
  set(gca, 'title', label);
  hold off;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function plot_rotations(test_image, figure_count, degrees)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        plot_rotations(test_image, figure_count, degrees)
%
%        Helper function that plots the various rotations of the original image.
%        It plots the nearest, bilinear and bicubic rotations of the original image.
%
%        test_image: image under investigation
%        figure_count: integer used to label the figure windows
%        degrees: How much to rotate the image. Valid rotations are 30, 45, 90, 135 degrees
%        
%        Author: John Lasheski
function plot_rotations(test_image, figure_count, degrees)
  
  % just some formatting for the titles of the plots
  if degrees == 30
    degrees_label = " 30 Degrees ";
  elseif degrees == 45
    degrees_label = " 45 Degrees ";
  elseif degrees == 90
    degrees_label = " 90 Degrees ";
  elseif degrees == 135
    degrees_label = " 135 Degrees ";
  end

  % create the rotated images
  imrotate(test_image, degrees);
  test_image_nearest = imrotate(test_image, degrees, 'nearest', 'crop');
  test_image_bilinear = imrotate (test_image, degrees, 'bilinear', 'crop');
  test_image_bicubic = imrotate(test_image, degrees, 'bicubic', 'crop');

  % create a figure to compare the results
  figure(figure_count)
  hold on;
 
  % plot the original image
  subplot(221)
  imshow(test_image);
  set(gca, 'title', 'Original Image');
  
  % display the rotated image using Nearest
  subplot(222);
  imshow(test_image_nearest);
  label = strcat("Image Rotated", degrees_label, " Using Nearest");  
  set(gca, 'title', label);

  % display the rotated image using Bilinear
  subplot(223);
  imshow(test_image_bilinear);
  label = strcat("Image Rotated", degrees_label, " Using Bilinear");  
  set(gca, 'title', label);

  % display the rotated image using Bicubic
  subplot(224);
  imshow(test_image_bicubic);
  label = strcat("Image Rotated", degrees_label, " Using Bicubic");  
  set(gca, 'title', label);
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function plot_shears(binary_image, figure_count, axis, alpha)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        plot_shears(binary_image, figure_count, axis, alpha)
%
%        Helper function that plots the various shears of the original image.
%        It plots the nearest, bilinear and bicubic shears of the original image.
%
%        binary_image: image under investigation in binary format
%        figure_count: integer used to label the figure windows
%        axis: which direction to shear, 'x' or 'y'
%        alpha: how much to shear the image by
%        
%        Author: John Lasheski
function plot_shears(binary_image, figure_count, axis, alpha)
   
  % create the translated images
  test_image_nearest = imshear(binary_image, axis, alpha, 'nearest', 'crop');
  test_image_bilinear = imshear(binary_image, axis, alpha, 'bilinear', 'crop');
  test_image_bicubic = imshear(binary_image, axis, alpha, 'bicubic', 'crop');
  
  % create a figure to compare the results
  figure(figure_count)
  hold on;
 
  % plot the original image
  subplot(221)
  imshow(binary_image);
  set(gca, 'title', 'Original Image');
  
  % display the translated image using Nearest
  subplot(222);
  imshow(test_image_nearest);
  label = strcat("Image Sheared Using Nearest");  
  set(gca, 'title', label);

  % display the translated image using Bilinear
  subplot(223);
  imshow(test_image_bilinear);
  label = strcat("Image Sheared Using Bilinear");
  set(gca, 'title', label);

  % display the translated image using Bicubic
  subplot(224);
  imshow(test_image_bicubic);
  label = strcat("Image Sheared Using Bicubic");
  set(gca, 'title', label);
  hold off;
end



% translate the image to the right by 5 and down by 8
% further translate the image for a more dramatic effect
% plot the results vs the original
plot_translations(binary_image, 1, 5, -8);
plot_translations(binary_image, 2, 500, -800);

% plot the rotated images
plot_rotations(test_image, 3, 30);
plot_rotations(test_image, 4, 45);
plot_rotations(test_image, 5, 90);
plot_rotations(test_image, 6, 135);

% plot the sheared images
plot_shears(binary_image, 7, 'y', .27);

