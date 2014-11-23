%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% discussion.m
% November 22, 2014
%
% Octave script file that calculates the histogram of an image. Image equalization
% is then run and another histogram is calculated. Plots of the images and their
% histograms are provided for comparison.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load the image
test_image = imread("guitar.jpg");

% calculate the statistics
Minimum = min(min(test_image));
Maximum = max(max(test_image));
Average = mean2(test_image);
Std_Dev = std2(test_image);

% print the statistics
printf("The minimum is %f, and the maximum is %f.\n", Minimum, Maximum);
printf("The average is %f, and the standard deviation is %f.\n", Average, Std_Dev);

% Calculate the original histogram, then equalize the image and calculate again
histogram = imhist(test_image);
eq_test_image = histeq(test_image, 256);
eq_histogram = imhist(eq_test_image);

% plot the original image, equalized images and their histograms
figure(1)
hold on;
subplot(221)
imshow(test_image);
set(gca, 'title', 'Original Image');

subplot(222)
plot(log10(histogram));
set(gca, 'title', "Original Histogram in Log 10 Scale");
set(gca, 'xlim', [0,256]);

subplot(223)
imshow(eq_test_image);
set(gca, 'title', 'Equalized Image');

subplot(224)
plot(log10(eq_histogram));
set(gca, 'title', 'Equalized Histogram in Log 10 Scale');
set(gca, 'xlim', [0,256]);
hold off;
