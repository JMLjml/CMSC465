%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw5.m
% December 1, 2014
%
% Octave script file that tests a function that reads in an image and a matrix
% representing an image filter. The function applies the filter to the image
% and returns the new modified image. The script tests out the function by
% calling three filters on an image and displaying the results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% load the image package tools
pkg load image;

% load our test image into octave
BW_test_image = imread('owl.jpg');
Color_test_image = imread('color_owl.jpg');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function [color, success] = check_colour(source)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        function [color, success] = check_colour(source)
%
%        Checks a source image's dimensions to determine if the image is
%        a color image or a grey scale image. Return parameter color will be
%        set to true if the image is a color image. Return parameter success
%        will be set to false if the image does not have valid dimensions
%
%        source = Matrix representing the image we are investigating
%        
%        Author: John Lasheski
function [color, success] = check_colour(source)
  success = true;

  % determine if the source image is greyscale [m,n] or color [m,n,3]
  if ndims(source) == 2
    color = false;
  elseif ndims(source) == 3
    color = true;
  else % source file dimensions are illegal
    printf('**ERROR** Illegal Image Dimensions in Source File.\n');
    success = false;
    color = false;
  end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function [m, n, success] = get_dimensions(source, color)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        function [m, n, success] = get_dimensions(source, color)
%
%        Checks and returns a source image's dimensions. Return parameters
%        m and n represent the m rows and n columns of the image size. Return
%        parameter success will be set to false if the image does not have
%        valid dimensions.
%
%        source = Matrix representing the image we are investigating
%        color = boolean set to true if the image is a color image
%        
%        Author: John Lasheski
function [m, n, success] = get_dimensions(source, color)
  success = true;

  % Store the size of the source image
  source_size = size(source);
  m = source_size(1);
  n = source_size(2);
  
  % test for illegal dimensions of the source file
  if color
    p = source_size(3);
  end

  if(color && p != 3)
    printf('**ERROR** Illegal Image Dimensions in Source File\n');
    success = false;
  end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function [q, success] = check_filter(transform)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        function [q, success] = check_filter(transform)
%
%        Test and store an image filter's dimensions.
%        Filter must be a square matrix of [q, q] and q must be an 
%        odd integer > 1. Return parameter q represent the size of the filter
%        and return parameter success will be set to false if the filter does
%        not have valid dimensions.
%
%        transform = Matrix representing the image filter we are investigating
%        
%        Author: John Lasheski
function [q, success] = check_filter(transform)
  success = true;
  
  [p,q] = size(transform);

  if (ndims(transform) != 2)  % The filter is not 2d
    printf('**ERROR** Illegal Filter Dimensions\n');
    success = false;
  elseif(p != q)  % The filter is not square
    printf('**ERROR** Illegal Filter Dimensions\n');
    success = false;
  elseif(mod(q,2) != 1 || q < 3)  % The filter is not an odd integer > 1
    printf('**ERROR** Illegal Filter Dimensions\n');
    success = false;
  end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function filtered_image = apply_filter(source, transform)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        function filtered_image = apply_filter(source, transform)
%
%        Applies and image filter to a source image and returns the newly
%        created modified image. Function works with both greyscale and
%        color images. Function calls a number of helper functions to test
%        and determine the dimensions of the source image and the filter.
%        The function does not pad the edges, therefore the edges are not
%        filtered
%
%        source = Matrix representing the image we are applying the filter to
%        transform = Matrix representing the image filter we are investigating
%        
%        Author: John Lasheski
function filtered_image = apply_filter(source, transform)
  % check the dimensions to determine if the image is greyscale or color
  [color, success] = check_colour(source);

  % the image had a invalid number of dimensions
  if (!success)
    break;
  end

  % get and store the size of the image
  [m, n, success] = get_dimensions(source, color);

  % the image had a invalid number of dimensions
  if (!success)
    break;
  end

  % check and make sure the filter is a valid size and shape
  [q, success] = check_filter(transform);

  % the filter had a invalid number of dimensions
  if (!success)
    break;
  end


  % create the return image matrix for storing the filtered results
  % and set p to the number of dimensions for later
  if color
    filtered_image = zeros(m, n, 3);
    p = 3;
  else
    filtered_image = zeros(m, n);
    p = 1;
  end


  % Do this so octave knows the image is 8 bit depth
  % it shows up as 1 bit depth otherwise
  filtered_image = uint8(filtered_image);

  % half of the filter size - this number is used a lot
  half = floor(q/2);

  % iterate over the source image and apply the filter
  % Store the filter values in the return image
  % k iteration will only occur once for greyscale and 
  % three times for a RGB image

  % sub is the small portion of the image that we are filtering at that moment
  
  for k = 1:p
    for i = (q - half) : (m - half)
      for j = (q - half) : (n - half)
        sub = source([(i-(half)):(i+(half))], [(j-half):(j+half)], k);
        filtered_image(i, j, k) = uint8(sum(sum(times(sub, transform))));
        j++;
      end  % end j
      i++;
    end  % end i
    k++;
  end  % end k
end  % End of apply_filter function



% define Test filters
Low_Pass_5 = repmat(1/25, 5, 5);
High_Pass_3 = [0 -1/4 0; -1/4 1.5 -1/4; 0 -1/4 0];
Edge_3 = [-1 -1 -1; -1 4 -1; -1 -1 -1];


% Apply the filters are store the results
BW_HP3_result = apply_filter(BW_test_image, High_Pass_3);
BW_Edge_result = apply_filter(BW_test_image, Edge_3);
color_result = apply_filter(Color_test_image, Low_Pass_5);


% plot the results for analysis

% BW image with High Pass 3
figure(1)
hold on;
subplot(121)
imshow(BW_test_image);
title('Original Greyscale Image', 'fontsize', 22);

subplot(122)
imshow(BW_HP3_result);
title('Greyscale Image with High Pass 3 Filter', 'fontsize', 22);
hold off;


% BW image with Motion Blur 5
figure(2)
hold on;
subplot(121)
imshow(BW_test_image);
title('Original Greyscale Image', 'fontsize', 22);

subplot(122)
imshow(BW_Edge_result);
title('Greyscale Image with Edge 3 Filter', 'fontsize', 22);
hold off;


% Color image with Low_Pass_5
figure(3)
hold on;
subplot(121)
imshow(Color_test_image);
title('Original Color Image', 'fontsize', 22);

subplot(122)
imshow(color_result);
title('Color Image with Low Pass 5 Filter', 'fontsize', 22);
hold off;
