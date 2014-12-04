%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw5.m
% December 1, 2014
%
% Octave script file that test a function that reads in an image and a matrix representing
% an image filter. The function applies the filter to the image and returns the new modified image.
% The script tests out the function by calling three filters on an image and displaying the results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% load the image package tools
pkg load image;

% load our test image into octave
test_image = imread('owl.jpg');



function [color, success] = check_colour(source)
  success = true;

  % determine if the source image is greyscale [m,n] or color [m,n,3]
  if ndims(source) == 2
    color = false;
  elseif ndims(source) == 3
    color = true;
  else % source file dimmensions are illegal
    printf('**ERROR** Illegal Image Dimmensions in Source File.\n');
    success = false;
    color = false;
  end
end


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
    printf('**ERROR** Illegal Image Dimmensions in Source File\n');
    success = false;
  end
end


function [q, success] = check_filter(transform)
  success = true;
  % Test and store filter dimmensions
  % Filter must be a square matrix of [Q, Q] and Q must be odd integer > 1
  [p,q] = size(transform);

  if (ndims(transform) != 2)  % The filter is not 2d
    printf('**ERROR** Illegal Filter Dimmensions\n');
    success = false;
  elseif(p != q)  % The filter is not square
    printf('**ERROR** Illegal Filter Dimmensions\n');
    success = false;
  elseif(mod(q,2) != 1 || q < 3)  % The filter is not an odd integer > 1
    printf('**ERROR** Illegal Filter Dimmensions\n');
    success = false;
  end
end


function filtered_image = apply_filter(source, transform)
  % check the number of dimensions to determine if the image is greyscal or color
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

  % check and make sure the filter is a vald size and shape
  [q, success] = check_filter(transform);

  % the filter had a invalid number of dimensions
  if (!success)
    break;
  end


  % create the return image matrix for storing the filtered results
  % and set RGB to the number of dimensions for later
  if color
    filtered_image = zeros(m, n, 3);
    RGB = 3;
  else
    filtered_image = zeros(m, n);
    RGB = 1;
  end


  % Do this so octave knows the image is 8 bit depth
  % it shows up as 1 bit depth otherwise
  filtered_image = uint8(filtered_image);

  % half of the filter size - this number is used a lot
  half = floor(q/2);

  % iterate over the source image and apply the filter
  % Store the filter values in the return image
  % k itereation will only occur once for greyscale and 
  % three times for RGB image

  % sub is the small portion of the image that we are filtering at that momenet
  
  for k = 1:RGB
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
Low_Pass_3 = repmat(1/9, 3, 3);
Low_Pass_5 = repmat(1/25, 5, 5);
Low_Pass_9 = repmat(1/81, 9, 9);

High_Pass_3 = [0 -1/4 0; -1/4 2 -1/4; 0 -1/4 0];


result = apply_filter(test_image, High_Pass_3);

figure(1)
hold on;
subplot(121)
imshow(test_image);

subplot(122)
imshow(result);
hold off;
