%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskiimage.m
% December 9, 2014
%
% Octave script file that explores how to use a minimum distance classifier to
% identify letters within images. Training Classes are supplied for each letter
% under investigation. This script looks at the letters 'J', 'O', and 'B'.
% Each training class has 25 image files. The image files are read in and 
% stored in a custom structure called either classJ, classO or classB.
% From here a stats function is called that calculates the average data
% values for each parameter that could be used to classify the images.
% The mean values are printed to the terminal and scatter plots are created to
% visualize the different parameters to determine which to use for the
% classifier. Finally the classifier is called on each image within the three
% training classes to see how well it works. The results of the classifier
% are also printed to the terminal.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% load the image package tools
pkg load image;

% create and load up the test classes
classJ = [];
classO = [];
classB = [];

% used for concat operation on string names
extension = '.bmp';

for i = 1:25
  
  % construct the filename to load for each class
  nameJ = 'j/j';
  nameO = 'o/o';
  nameB = 'b/b';

  index = int2str(i);

  % concat the file name parts together
  nameJ = strcat(nameJ,index,extension);
  nameO = strcat(nameO,index,extension);
  nameB = strcat(nameB,index,extension);

  % read in each image file, take it's complement, convert to binary, 
  % and store it in a custom structure of images
  
  classJ(i).index = i;
  classJ(i).image = im2bw(imcomplement(imread(nameJ)));

  classO(i).index = i;
  classO(i).image = im2bw(imcomplement(imread(nameO)));

  classB(i).index = i;
  classB(i).image = im2bw(imcomplement(imread(nameB)));

  i++;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function Letter = create_class(Letter)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        function Letter = create_class(Letter)
%
%        Further develops and creates a structure for holding relevant
%        statistics about a training class. Letter is the basic structure
%        that was instantiated above with and image file and an index number.
%        
%        Letter = structure holding the images we are investigating
%        
%        Author: John Lasheski
function Letter = create_class(Letter)
  for i = 1 : 25 % repeat for each image in the training class
    
    Letter(i).B = bwboundaries(Letter(i).image);
    Letter(i).boundary = Letter(i).B{1};
    Letter(i).FCC = fchcode(Letter(i).boundary);
    
    Letter(i).Area = sum(regionprops(Letter(i).image, 'Area').Area);
    
    Letter(i).Perimeter = ...
     sum(regionprops(Letter(i).image, 'Perimeter').Perimeter);
    
    Letter(i).Orientation = ...
     regionprops(Letter(i).image, 'Orientation').Orientation;
    
    Letter(i).Extent = min(regionprops(Letter(i).image, 'Extent').Extent);

    Letter(i).EquivDiameter = Letter(i).Area * 4 / pi;

    Letter(i).EulerNumber = (regionprops(Letter(i).image, 'EulerNumber'));

    % this works to correct the issues I am having with extra holes
    if(!isscalar(Letter(i).EulerNumber))
      Letter(i).EulerNumber = Letter(i).EulerNumber(1);
    end
    i++;
  end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function count = count_changes(FCC)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        function count = count_changes(FCC)
%
%        a simple function for counting the number of direction changes
%        picked up using Freeman's CH Code
%        
%        FCC = vector of fcc directions
%        
%        Author: John Lasheski
function count = count_changes(FCC)
  count = 0;
  for i = 1 : length(FCC) - 1
    if(FCC(i) != FCC(i+1))
      count++;
    end
  i++;
  end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function stats = create_stats(stats, Letter, Index)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        function stats = create_stats(stats, Letter, Index)
%
%        Creates a structure for holding relevant statistics about all
%        of the training classes under investigation. create_stats also
%        calculates the mean of each data type for later use by the 
%        minimum distance classifier. 
%
%        stats = the structure we are creating, an empty structure should be
%                passed in on the first call to the function
%        Letter = structure holding the images we are investigating
%        Index = start at 1 and count upwards to keep track of each class        
%        
%        Author: John Lasheski
function stats = create_stats(stats, Letter, Index)
  for i = 1 : 25 % calculate stats for each image
    stats(Index).FCC(i) = sum(Letter(i).FCC.fcc);
    stats(Index).Area(i) = Letter(i).Area;
    stats(Index).Orientation(i) = Letter(i).Orientation;
    stats(Index).Perimeter(i) = Letter(i).Perimeter;
    stats(Index).EquivDiameter(i) = Letter(i).EquivDiameter;
    stats(Index).EulerNumber(i) = Letter(i).EulerNumber.EulerNumber;
    stats(Index).Extent(i) = Letter(i).Extent;
    stats(Index).Count = count_changes(Letter(i).FCC.fcc);
    i++;
  end

  % calculate the mean values of each stat
  stats(Index).mean_FCC = mean(stats(Index).FCC);
  stats(Index).mean_Area = mean(stats(Index).Area);
  stats(Index).mean_Perimeter = mean(stats(Index).Perimeter);
  stats(Index).mean_EquivDiameter = mean(stats(Index).EquivDiameter);
  stats(Index).mean_Orientation = mean(stats(Index).Orientation);
  stats(Index).mean_EulerNumber = mean(stats(Index).EulerNumber);
  stats(Index).mean_Extent = mean(stats(Index).Extent);
  stats(Index).mean_Count = mean(stats(Index).Count);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function Test = classify(Letter, Test, stats, Index)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        function Test = classify(Letter, Test, stats, Index)
%
%        classify is a minimum distance classifier function. It looks
%        at each of the training classes and all of the sample images.
%        It compares an individual image's stats vs the mean stats for each 
%        training class we have studied. It applies a weighting vector W
%        to weight the various data parameters we use to classification.
%        The results of the comparisons are tallied and stored in a structure
%        called Test.
%
%        Test = the structure we are creating, an empty structure should be
%                passed in on the first call to the function
%        Letter = structure holding the images we are investigating
%        stats = structure holding the data for each image set
%        Index = start at 1 and count upwards to keep track of each class        
%        
%        Author: John Lasheski
function Test = classify(Letter, Test, stats, Index)
  % create the weightings vector
  W = [10 .5 .2 .05 .155 .32];

  % create the classification matrix. Each row will represent a class
  % and each column stores the mean value of the parameter we are using
  C = zeros(3,6);

  for i = 1 : 3
    C(i,1) = int8(stats(i).mean_EulerNumber);  % Round to whole numbers
    C(i,2) = stats(i).mean_Extent;
    C(i,3) = stats(i).mean_Orientation;
    C(i,4) = stats(i).mean_Perimeter;
    C(i,5) = stats(i).mean_FCC;
    C(i,6) = stats(i).mean_Area;

    i++;
  end

  % count the number of times we classify each letter
  Test(Index).Jcount = 0;
  Test(Index).Ocount = 0;
  Test(Index).Bcount = 0;
  

  % iterate through each test case in a given class Letter
  for j = 1 : 25
    % used to store the distance results
    Distance = zeros(3,1);

    % iterate through the three possible classes that could be a match and
    % store the classification distance from each in the Distance vector
    for k = 1 : 3
      EN = W(1) * abs(Letter(j).EulerNumber.EulerNumber - C(k,1));
      EXT = W(2) * abs(Letter(j).Extent - C(k,2));
      FCC = W(5) * abs(sum(Letter(j).FCC.fcc) - C(k,5));
      PER = W(4) * abs(Letter(j).Perimeter - C(k,4));
      ORR = W(3) * abs(Letter(j).Orientation - C(k,3));
      AREA = W(6) * abs(Letter(j).Area - C(k,6));

      Distance(k) = EN + EXT + ORR + PER + FCC + AREA;
      k++;
    end

    % Find the index number of the smallest distance, this is the letter
    % we identified
    [M, position] = min(Distance);

    % increment the count within the Test structure for the letter identified
    switch(position)
      case 1
        Test(Index).Jcount++;
      case 2
        Test(Index).Ocount++;
      case 3
        Test(Index).Bcount++;
    end

    j++;
  end  % end j for loop
end  % end of classify function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Create the classes, the statistics, and run the minimum distance classifier
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create all of the test classes and then store their statistics in the 
% stats structure
classJ = create_class(classJ);
classO = create_class(classO);
classB = create_class(classB);

% instantiate the stats structure and create the stats
stats = [];
stats = create_stats(stats, classJ, 1);
stats = create_stats(stats, classO, 2);
stats = create_stats(stats, classB, 3);

% instantiate the Test Structure
Test = [];

% Call classify method three times, once for each test class
Test = classify(classJ, Test, stats, 1);
Test = classify(classO, Test, stats, 2);
Test = classify(classB, Test, stats, 3);

% calculate the success ratio for each training class
Test(1).percent = Test(1).Jcount / 25 * 100;
Test(2).percent = Test(2).Ocount / 25 * 100;
Test(3).percent = Test(3).Bcount / 25 * 100;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print the mean values for each of the classification parameters
% in the minimum distance classifier
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf('\n*************************************************\n')
printf('       Mean Values of Data for Training Sets\n');
printf('*************************************************\n')
for i = 1 : 3
  switch(i)
    case 1
      printf('\n*** Stats for Training Set J ***\n');
    case 2
      printf('\n*** Stats for Training Set O ***\n');
    case 3
      printf('\n*** Stats for Training Set B ***\n');
  end

  printf('The mean FCC value is: %f\n', stats(i).mean_FCC);
  printf('The mean Area value is %f\n', stats(i).mean_Area);
  printf('The mean Perimeter value is %f\n', stats(i).mean_Perimeter);
  printf('The mean EquivDiameter value is %f\n', stats(i).mean_EquivDiameter);
  printf('The mean Orientation value is %f\n', stats(i).mean_Orientation);
  printf('The mean EulerNumber value is %f\n', stats(i).mean_EulerNumber);
  printf('The mean Extent value is %f\n', stats(i).mean_Extent);
  printf('The mean Count value is %f\n', stats(i).mean_Count);
  i++;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% print the results from the classification trials
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printf('\n*************************************************\n')
printf('       Results of Classification Trials\n');
printf('*************************************************\n\n')
printf('*** Results for Training Set J ***\n')
printf('Identified %d J''s, %d O''s, and %d B''s.\n', Test(1).Jcount,...
 Test(1).Ocount, Test(1).Bcount);
printf('Percent Correctly Identified was %d%%.\n\n', Test(1).percent);

printf('*** Results for Training Set O ***\n')
printf('Identified %d J''s, %d O''s, and %d B''s.\n', Test(2).Jcount,...
 Test(2).Ocount, Test(2).Bcount);
printf('Percent Correctly Identified was %d%%.\n\n', Test(2).percent);

printf('*** Results for Training Set B ***\n')
printf('Identified %d J''s, %d O''s, and %d B''s.\n', Test(3).Jcount,...
 Test(3).Ocount, Test(3).Bcount);
printf('Percent Correctly Identified was %d%%.\n\n', Test(3).percent);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print the scatter plots used to determine the weightings for each
% classification parameter in the minimum distance classifier
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colors = ['g'; 'r'; 'm'];


% FCC vs Area Scatter Plot
figure(1)
hold on;
for i = 1 : 3
  scatter(stats(i).FCC, stats(i).Area, colors(i), 'filled');
  scatter(stats(i).mean_FCC, stats(i).mean_Area, 20, colors(i),...
    'd', 'linewidth', 2); 
  i++;
end

xlabel('Sum of FCC', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
title('Scatter Plot of FCC vs Area', 'fontsize', 14);
hold off;



% Perimeter vs Area Scatter Plot
figure(2)
hold on;
for i = 1 : 3
  scatter(stats(i).Perimeter, stats(i).Area, colors(i), 'filled'); 
  scatter(stats(i).mean_Perimeter, stats(i).mean_Area, 20, colors(i),...
    'd', 'linewidth', 2); 
  i++;
end

xlabel('Perimeter', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
title('Scatter Plot of Perimeter vs Area', 'fontsize', 14);
hold off;



% EquivDiameter vs Area Scatter Plot
figure(3)
hold on;
for i =1 : 3
  scatter(stats(i).EquivDiameter, stats(i).Area, colors(i), 'filled');
  scatter(stats(i).mean_EquivDiameter, stats(i).mean_Area, 20, colors(i),...
    'd', 'linewidth', 2); 
  i++;
end

xlabel('EquivDiameter', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
title('Scatter Plot of EquivDiameter vs Area', 'fontsize', 14);
hold off;



% Orientation vs Area Scatter Plot
figure(4)
hold on;
for i = 1 : 3
  scatter(stats(i).Orientation, stats(i).Area, colors(i), 'filled');
  scatter(stats(i).mean_Orientation, stats(i).mean_Area, 20, colors(i),...
   'd', 'linewidth', 2);
  i++;
end

xlabel('Orientation', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
title('Scatter Plot of Orientation vs Area', 'fontsize', 14);
hold off;




% EulerNumber vs Area Scatter Plot
figure(5)
hold on;
for i = 1 : 3
  scatter(stats(i).EulerNumber, stats(i).Area, colors(i), 'filled');
  scatter(stats(i).mean_EulerNumber, stats(i).mean_Area, 20, colors(i),...
   'd', 'linewidth', 2); 
  i++;
end

xlabel('EulerNumber', 'fontsize', 14);
ylabel('Area', 'fontsize', 14);
title('Scatter Plot of EulerNumber vs Area', 'fontsize', 14);
hold off;



% Extent vs Area Scatter Plot
figure(6)
hold on;
for i = 1 : 3
  scatter(stats(i).Extent, stats(i).Area, colors(i), 'filled');
  scatter(stats(i).mean_Extent, stats(i).mean_Area, 20, colors(i),...
   'd', 'LineWidth', 2);
  i++;
end

xlabel('Extent', 'fontsize', 14);
ylabel('Area', 'fontsize', 14);
title('Scatter Plot of Extent vs Area', 'fontsize', 14);
hold off;



% Count vs Area Scatter Plot
figure(7)
hold on;
for i = 1 : 3
  scatter(stats(i).Count, stats(i).Area, colors(i), 'filled');
  scatter(stats(i).mean_Count, stats(i).mean_Area, 20, colors(i),...
   'd', 'LineWidth', 2);
  i++;
end

xlabel('Count', 'fontsize', 14);
ylabel('Area', 'fontsize', 14);
title('Scatter Plot of Count vs Area', 'fontsize', 14);
hold off;
