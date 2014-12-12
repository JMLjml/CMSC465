%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskiimage.m
% December 9, 2014
%
% Octave script file that 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% load the image package tools
pkg load image;

% create and load up the test classes
classJ = [];
classO = [];
classB = [];

% used for concat opperation on string names
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


% run statistics on each class, calculate the mean, and store it in vector
% of class properties
% also plot the stats as a scatter plot to check them out

% need to do bwboundary, Freemans code, Boundary length, boundary diameter

% make this into a function or clean it up somehow



function Letter = create_class(Letter)
  for i = 1 : 25
    
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


function count = count_changes(FCC)
  count = 0;
  for i = 1 : length(FCC) - 1
    if(FCC(i) != FCC(i+1))
      count++;
    end
  i++;
  end
end
    


function stats = create_stats(stats, Letter, index)
  for i = 1 : 25
    stats(index).FCC(i) = sum(Letter(i).FCC.fcc);
    stats(index).Area(i) = Letter(i).Area;
    stats(index).Orientation(i) = Letter(i).Orientation;
    stats(index).Perimeter(i) = Letter(i).Perimeter;
    stats(index).EquivDiameter(i) = Letter(i).EquivDiameter;
  
    % stats(index).EulerNumber(i) = Letter(i).EulerNumber;
    stats(index).EulerNumber(i) = Letter(i).EulerNumber.EulerNumber;
    stats(index).Extent(i) = Letter(i).Extent;
    i++;
  end

  stats(index).mean_FCC = mean(stats(index).FCC);
  stats(index).mean_Area = mean(stats(index).Area);
  stats(index).mean_Perimeter = mean(stats(index).Perimeter);
  stats(index).mean_EquivDiameter = mean(stats(index).EquivDiameter);
  stats(index).mean_Orientation = mean(stats(index).Orientation);
  stats(index).mean_EulerNumber = mean(stats(index).EulerNumber);
  stats(index).mean_Extent = mean(stats(index).Extent);

end






classJ = create_class(classJ);
classO = create_class(classO);
classB = create_class(classB);
stats = [];
stats = create_stats(stats, classJ, 1);
stats = create_stats(stats, classO, 2);
stats = create_stats(stats, classB, 3);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print the mean values for each of the classification parameters
% in the minimum distance classifier
%
% Turn this into a for loop
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


printf('\n*** For Class J ***\n');
printf('The mean FCC value is: %f\n', stats(1).mean_FCC);
printf('The mean Area value is %f\n', stats(1).mean_Area);
printf('The mean Perimeter value is %f\n', stats(1).mean_Perimeter);
printf('The mean EquivDiameter value is %f\n', stats(1).mean_EquivDiameter);
printf('The mean Orientation value is %f\n', stats(1).mean_Orientation);
printf('The mean EulerNumber value is %f\n', stats(1).mean_EulerNumber);
printf('The mean Extent value is %f\n', stats(1).mean_Extent);



printf('\n*** For Class O ***\n');
printf('The mean FCC value is: %f\n', stats(2).mean_FCC);
printf('The mean Area value is %f\n', stats(2).mean_Area);
printf('The mean Perimeter value is %f\n', stats(2).mean_Perimeter);
printf('The mean EquivDiameter value is %f\n', stats(2).mean_EquivDiameter);
printf('The mean Orientation value is %f\n', stats(2).mean_Orientation);
printf('The mean EulerNumber value is %f\n', stats(2).mean_EulerNumber);
printf('The mean Extent value is %f\n', stats(2).mean_Extent);



printf('\n*** For Class B ***\n');
printf('The mean FCC value is: %f\n', stats(3).mean_FCC);
printf('The mean Area value is %f\n', stats(3).mean_Area);
printf('The mean Perimeter value is %f\n', stats(3).mean_Perimeter);
printf('The mean EquivDiameter value is %f\n', stats(3).mean_EquivDiameter);
printf('The mean Orientation value is %f\n', stats(3).mean_Orientation);
printf('The mean EulerNumber value is %f\n', stats(3).mean_EulerNumber);
printf('The mean Extent value is %f\n\n', stats(3).mean_Extent);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% minimum distance classifier section
%
% turn this into a function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% create the weighitngs vector
W = [1 1 1 1];

% create the classification matrix. Each rwo will represent a class
% and each colunm stores the mean value of the parameter we are using
C = zeros(3,4);

for i = 1 : 3
  C(i,1) = int8(stats(i).mean_EulerNumber);  % Round to whole numbers
  C(i,2) = stats(i).mean_Extent;
  C(i,3) = stats(i).mean_FCC;
  C(i,4) = stats(i).mean_Perimeter;
  i++;
end

% apply the weightings
% C = W .* C;


% I would rather make this a method and call it 3 times
% itereate over each class
% for i = 1 : 3

  % itereate through each test case in a given class
  for j = 1 : 25
  
    % used to store the distance results
    Distance = zeros(3,1);

    % iterate through the three possible classes that could be a match and
    % store the classifcation distance from each in the Distance vector
    for k = 1 : 3
      
      % EN = abs(classJ(j).EulerNumber - C(k,1));
      EN = abs(classJ(j).EulerNumber.EulerNumber - C(k,1));
      EXT = abs(classJ(j).Extent - C(k,2));
      FCC = abs(sum(classJ(j).FCC.fcc) - C(k,3));
      PER = abs(classJ(j).Perimeter - C(k,4));

      Distance(k) = EN + EXT + FCC + PER;

      k++;
    end

    [M, Index] = min(Distance);


    switch(Index)
      case 1
        printf('Identified Letter J.\n');
      case 2
        printf('Identified Letter O.\n');
      case 3
        printf('Identified Letter B.\n');
    end

    j++;
  end  % end j for loop

  % i++;
% end  % end of i for loop


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Print the scatter plots used to determine the weigtings for each
% classification parameter in the minimum distance classifier
%
% convert these all to for loops
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FCC vs Area Scatter Plot
figure(1)
hold on;
a = 10;
scatter(stats(1).FCC, stats(1).Area, a, 'g', 'filled') 
scatter(stats(1).mean_FCC, stats(1).mean_Area, 20, 'g', 'filled') 

scatter(stats(2).FCC, stats(2).Area, a, 'r', 'filled') 
scatter(stats(2).mean_FCC, stats(2).mean_Area, 20, 'r', 'filled') 

scatter(stats(3).FCC, stats(3).Area, a, 'm', 'filled') 
scatter(stats(3).mean_FCC, stats(3).mean_Area, 20, 'm', 'filled')

xlabel('Sum of FCC', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of FCC vs Area', 'fontsize', 14);
hold off;




% Perimeter vs Area Scatter Plot
figure(2)
hold on;
a = 10;
scatter(stats(1).Perimeter, stats(1).Area, a, 'g', 'filled') 
scatter(stats(1).mean_Perimeter, stats(1).mean_Area, 20, 'g', 'filled') 

scatter(stats(2).Perimeter, stats(2).Area, a, 'r', 'filled') 
scatter(stats(2).mean_Perimeter, stats(2).mean_Area, 20, 'r', 'filled') 

scatter(stats(3).Perimeter, stats(3).Area, a, 'm', 'filled') 
scatter(stats(3).mean_Perimeter, stats(3).mean_Area, 20, 'm', 'filled')

xlabel('Perimeter', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of Perimeter vs Area', 'fontsize', 14);
hold off;



% EquivDiameter vs Area Scatter Plot
figure(3)
hold on;
a = 10;
scatter(stats(1).EquivDiameter, stats(1).Area, a, 'g', 'filled') 
scatter(stats(1).mean_EquivDiameter, stats(1).mean_Area, 20, 'g', 'filled') 

scatter(stats(2).EquivDiameter, stats(2).Area, a, 'r', 'filled') 
scatter(stats(2).mean_EquivDiameter, stats(2).mean_Area, 20, 'r', 'filled') 

scatter(stats(3).EquivDiameter, stats(3).Area, a, 'm', 'filled') 
scatter(stats(3).mean_EquivDiameter, stats(3).mean_Area, 20, 'm', 'filled')

xlabel('EquivDiameter', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of EquivDiameter vs Area', 'fontsize', 14);
hold off;



% Orientation vs Area Scatter Plot
figure(4)
hold on;
a = 10;
scatter(stats(1).Orientation, stats(1).Area, a, 'g', 'filled') 
scatter(stats(1).mean_Orientation, stats(1).mean_Area, 20, 'g', 'filled') 

scatter(stats(2).Orientation, stats(2).Area, a, 'r', 'filled') 
scatter(stats(2).mean_Orientation, stats(2).mean_Area, 20, 'r', 'filled') 

scatter(stats(3).Orientation, stats(3).Area, a, 'm', 'filled') 
scatter(stats(3).mean_Orientation, stats(3).mean_Area, 20, 'm', 'filled')

xlabel('Orientation', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of Orientation vs Area', 'fontsize', 14);
hold off;



% EulerNumber vs Area Scatter Plot
figure(5)
hold on;
a = 10;
scatter(stats(1).EulerNumber, stats(1).Area, a, 'g', 'filled') 
scatter(stats(1).mean_EulerNumber, stats(1).mean_Area, 20, 'g', 'filled') 

scatter(stats(2).EulerNumber, stats(2).Area, a, 'r', 'filled') 
scatter(stats(2).mean_EulerNumber, stats(2).mean_Area, 20, 'r', 'filled') 

scatter(stats(3).EulerNumber, stats(3).Area, a, 'm', 'filled') 
scatter(stats(3).mean_EulerNumber, stats(3).mean_Area, 20, 'm', 'filled')

xlabel('EulerNumber', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of EulerNumber vs Area', 'fontsize', 14);
hold off;





% Extent vs Area Scatter Plot
figure(6)
hold on;
a = 10;
scatter(stats(1).Extent, stats(1).Area, a, 'g', 'filled') 
scatter(stats(1).mean_Extent, stats(1).mean_Area, 20, 'g', 'filled') 

scatter(stats(2).Extent, stats(2).Area, a, 'r', 'filled') 
scatter(stats(2).mean_Extent, stats(2).mean_Area, 20, 'r', 'filled') 

scatter(stats(3).Extent, stats(3).Area, a, 'm', 'filled') 
scatter(stats(3).mean_Extent, stats(3).mean_Area, 20, 'm', 'filled')

xlabel('Extent', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of Extent vs Area', 'fontsize', 14);
hold off;


figure(7)
hold on;

colors = ['g'; 'r'; 'm'];

for i = 1 : 3
  scatter(stats(i).Extent, stats(i).Area, colors(i), 'filled');
  scatter(stats(i).mean_Extent, stats(i).mean_Area, 20, colors(i), 'd', 'LineWidth', 2)
  i++;
end

xlabel('Extent', 'fontsize', 14);
ylabel('Area', 'fontsize', 14);
title('Scatter Plot of Extent vs Area', 'fontsize', 14);
hold off;
