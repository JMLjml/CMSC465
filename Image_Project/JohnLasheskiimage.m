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

% used for concat op on string names
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






for i = 1:25
  B = bwboundaries(classJ(i).image);
  boundary = B{1};
  fcc = fchcode(boundary);
  s = regionprops(classJ(i).image, 'Area', 'Perimeter', 'Orientation', 'Extent');

  classJ(i).B = B;
  classJ(i).boundary = boundary;
  classJ(i).fcc = fcc;
  classJ(i).s = s;
  area = classJ(i).s.Area; % this is stupid
  EquivDiameter = area * 4 / pi;
  classJ(i).EquivDiameter = EquivDiameter;

  


  % classJ(i).EulerNumber = bweuler(classJ(i).image);
  classJ(i).EulerNumber = (regionprops(classJ(i).image, 'EulerNumber'));

  
  % this works to correct the issues I am having with extra holes
  if(!isscalar(classJ(i).EulerNumber))
    classJ(i).EulerNumber = classJ(i).EulerNumber(1);
  end

  % classJ(i).s.Extent = min(classJ(i).s.Extent);

  % octave sucks
  % this selects the min extent
  % anything with a hole in it is returning a cs-list
  % permiter is fucked up too
  classJ(i).Extent = min(regionprops(classJ(i).image, 'Extent').Extent);  
  


  % classJ(i).EulerNumber = regionprops(imcomplement(classJ(i).image), 'EulerNumber');
  i++;
end





for i = 1:25
  B = bwboundaries(classO(i).image);
  boundary = B{1};
  fcc = fchcode(boundary);
  s = regionprops(classO(i).image, 'Area', 'Perimeter', 'Orientation', 'Extent');

  classO(i).B = B;
  classO(i).boundary = boundary;
  classO(i).fcc = fcc;
  classO(i).s = s;
  area = classO(i).s.Area; % this is stupid try Area.Area it is a scalar...
  EquivDiameter = area * 4 / pi;
  classO(i).EquivDiameter = EquivDiameter;

  classO(i).EulerNumber = bweuler(classO(i).image);
  % classO(i).EulerNumber = regionprops(classO(i).image, 'EulerNumber');
  % classO(i).EulerNumber = regionprops(imcomplement(classO(i).image), 'EulerNumber');

  i++;
end




for i = 1:25
  B = bwboundaries(classB(i).image);
  boundary = B{1};
  fcc = fchcode(boundary);
  s = regionprops(classB(i).image, 'Area', 'Perimeter', 'Orientation', 'Extent');

  classB(i).B = B;
  classB(i).boundary = boundary;
  classB(i).fcc = fcc;
  classB(i).s = s;
  area = classB(i).s.Area; % this is stupid
  EquivDiameter = area * 4 / pi;
  classB(i).EquivDiameter = EquivDiameter;
  
  classB(i).EulerNumber = bweuler(classB(i).image);
  % classB(i).EulerNumber = regionprops(classB(i).image, 'EulerNumber');
  % classB(i).EulerNumber = regionprops(imcomplement(classB(i).image), 'EulerNumber');

  i++;
end




% make another structure here to store all of this stuff
% stats(1) is for classJ, stats(2) for classO and stats(3) for classB

for i = 1:25
  stats.fcc(i) = sum(classJ(i).fcc.fcc);
  stats.area(i) = classJ(i).s.Area;
  stats.Perimeter(i) = classJ(i).s.Perimeter;
  stats.Orientation(i) = classJ(i).s.Orientation;
  stats.EquivDiameter(i) = classJ(i).EquivDiameter;
  
  % stats.EulerNumber(i) = classJ(i).EulerNumber;
  stats.EulerNumber(i) = classJ(i).EulerNumber.EulerNumber;
  stats.Extent(i) = classJ(i).Extent;
  i++;
end

stats.mean_fcc = mean(stats.fcc);
stats.mean_area = mean(stats.area);
stats.mean_Perimeter = mean(stats.Perimeter);
stats.mean_EquivDiameter = mean(stats.EquivDiameter);
stats.mean_Orientation = mean(stats.Orientation);
stats.mean_EulerNumber = mean(stats.EulerNumber);
stats.mean_Extent = mean(stats.Extent);

for i = 1:25
  stats(2).fcc(i) = sum(classO(i).fcc.fcc);
  stats(2).area(i) = classO(i).s.Area;
  stats(2).Orientation(i) = classO(i).s.Orientation;
  stats(2).Perimeter(i) = classO(i).s.Perimeter;
  stats(2).EquivDiameter(i) = classO(i).EquivDiameter;
  
  stats(2).EulerNumber(i) = classO(i).EulerNumber;
  % stats(2).EulerNumber(i) = classO(i).EulerNumber.EulerNumber;
  stats(2).Extent(i) = classO(i).s.Extent;
  i++;
end


stats(2).mean_fcc = mean(stats(2).fcc);
stats(2).mean_area = mean(stats(2).area);
stats(2).mean_Perimeter = mean(stats(2).Perimeter);
stats(2).mean_EquivDiameter = mean(stats(2).EquivDiameter);
stats(2).mean_Orientation = mean(stats(2).Orientation);
stats(2).mean_EulerNumber = mean(stats(2).EulerNumber);
stats(2).mean_Extent = mean(stats(2).Extent);


for i = 1:25
  stats(3).fcc(i) = sum(classB(i).fcc.fcc);
  stats(3).area(i) = classB(i).s.Area;
  stats(3).Orientation(i) = classB(i).s.Orientation;
  stats(3).Perimeter(i) = classB(i).s.Perimeter;
  stats(3).EquivDiameter(i) = classB(i).EquivDiameter;
  
  stats(3).EulerNumber(i) = classB(i).EulerNumber;
  % stats(3).EulerNumber(i) = classB(i).EulerNumber.EulerNumber;
  stats(3).Extent(i) = classB(i).s.Extent;
  i++;
end


stats(3).mean_fcc = mean(stats(3).fcc);
stats(3).mean_area = mean(stats(3).area);
stats(3).mean_Perimeter = mean(stats(3).Perimeter);
stats(3).mean_EquivDiameter = mean(stats(3).EquivDiameter);
stats(3).mean_Orientation = mean(stats(3).Orientation);
stats(3).mean_EulerNumber = mean(stats(3).EulerNumber);
stats(3).mean_Extent = mean(stats(3).Extent);




printf('\n*** For Class J ***\n');
printf('The mean FCC value is: %f\n', stats(1).mean_fcc);
printf('The mean Area value is %f\n', stats(1).mean_area);
printf('The mean Perimeter value is %f\n', stats(1).mean_Perimeter);
printf('The mean EquivDiameter value is %f\n', stats(1).mean_EquivDiameter);
printf('The mean Orientation value is %f\n', stats(1).mean_Orientation);
printf('The mean EulerNumber value is %f\n', stats(1).mean_EulerNumber);
printf('The mean Extent value is %f\n', stats(1).mean_Extent);



printf('\n*** For Class O ***\n');
printf('The mean FCC value is: %f\n', stats(2).mean_fcc);
printf('The mean Area value is %f\n', stats(2).mean_area);
printf('The mean Perimeter value is %f\n', stats(2).mean_Perimeter);
printf('The mean EquivDiameter value is %f\n', stats(2).mean_EquivDiameter);
printf('The mean Orientation value is %f\n', stats(2).mean_Orientation);
printf('The mean EulerNumber value is %f\n', stats(2).mean_EulerNumber);
printf('The mean Extent value is %f\n', stats(2).mean_Extent);



printf('\n*** For Class B ***\n');
printf('The mean FCC value is: %f\n', stats(3).mean_fcc);
printf('The mean Area value is %f\n', stats(3).mean_area);
printf('The mean Perimeter value is %f\n', stats(3).mean_Perimeter);
printf('The mean EquivDiameter value is %f\n', stats(3).mean_EquivDiameter);
printf('The mean Orientation value is %f\n', stats(3).mean_Orientation);
printf('The mean EulerNumber value is %f\n', stats(3).mean_EulerNumber);
printf('The mean Extent value is %f\n\n', stats(3).mean_Extent);



% create the weighitngs vector
W = [1 1 1 1];

% create the classification matrix. Each rwo will represent a class
% and each colunm stores the mean value of the parameter we are using
C = zeros(3,4);

for i = 1 : 3
  C(i,1) = int8(stats(i).mean_EulerNumber);  % Round to whole numbers
  C(i,2) = stats(i).mean_Extent;
  C(i,3) = stats(i).mean_fcc;
  C(i,4) = stats(i).mean_Perimeter;
  i++;
end

% apply the weightings
% C = W .* C;

% classJ(15) and 23 has a fucked up EulerNumber?
% I think it is the space between the top of the j and the downstroke
% it is messing up the Extent operation too?
% classJ(15).EulerNumber.EulerNumber


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
      FCC = abs(sum(classJ(j).fcc.fcc) - C(k,3));
      PER = abs(classJ(j).s.Perimeter - C(k,4));

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




% FCC vs Area Scatter Plot
figure(1)
hold on;
a = 10;
scatter(stats(1).fcc, stats(1).area, a, 'g', 'filled') 
scatter(stats(1).mean_fcc, stats(1).mean_area, 20, 'g', 'filled') 

scatter(stats(2).fcc, stats(2).area, a, 'r', 'filled') 
scatter(stats(2).mean_fcc, stats(2).mean_area, 20, 'r', 'filled') 

scatter(stats(3).fcc, stats(3).area, a, 'm', 'filled') 
scatter(stats(3).mean_fcc, stats(3).mean_area, 20, 'm', 'filled')

xlabel('Sum of FCC', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of FCC vs Area', 'fontsize', 14);
hold off;




% Perimeter vs Area Scatter Plot
figure(2)
hold on;
a = 10;
scatter(stats(1).Perimeter, stats(1).area, a, 'g', 'filled') 
scatter(stats(1).mean_Perimeter, stats(1).mean_area, 20, 'g', 'filled') 

scatter(stats(2).Perimeter, stats(2).area, a, 'r', 'filled') 
scatter(stats(2).mean_Perimeter, stats(2).mean_area, 20, 'r', 'filled') 

scatter(stats(3).Perimeter, stats(3).area, a, 'm', 'filled') 
scatter(stats(3).mean_Perimeter, stats(3).mean_area, 20, 'm', 'filled')

xlabel('Perimeter', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of Perimeter vs Area', 'fontsize', 14);
hold off;



% EquivDiameter vs Area Scatter Plot
figure(3)
hold on;
a = 10;
scatter(stats(1).EquivDiameter, stats(1).area, a, 'g', 'filled') 
scatter(stats(1).mean_EquivDiameter, stats(1).mean_area, 20, 'g', 'filled') 

scatter(stats(2).EquivDiameter, stats(2).area, a, 'r', 'filled') 
scatter(stats(2).mean_EquivDiameter, stats(2).mean_area, 20, 'r', 'filled') 

scatter(stats(3).EquivDiameter, stats(3).area, a, 'm', 'filled') 
scatter(stats(3).mean_EquivDiameter, stats(3).mean_area, 20, 'm', 'filled')

xlabel('EquivDiameter', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of EquivDiameter vs Area', 'fontsize', 14);
hold off;



% Orientation vs Area Scatter Plot
figure(4)
hold on;
a = 10;
scatter(stats(1).Orientation, stats(1).area, a, 'g', 'filled') 
scatter(stats(1).mean_Orientation, stats(1).mean_area, 20, 'g', 'filled') 

scatter(stats(2).Orientation, stats(2).area, a, 'r', 'filled') 
scatter(stats(2).mean_Orientation, stats(2).mean_area, 20, 'r', 'filled') 

scatter(stats(3).Orientation, stats(3).area, a, 'm', 'filled') 
scatter(stats(3).mean_Orientation, stats(3).mean_area, 20, 'm', 'filled')

xlabel('Orientation', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of Orientation vs Area', 'fontsize', 14);
hold off;



% EulerNumber vs Area Scatter Plot
figure(5)
hold on;
a = 10;
scatter(stats(1).EulerNumber, stats(1).area, a, 'g', 'filled') 
scatter(stats(1).mean_EulerNumber, stats(1).mean_area, 20, 'g', 'filled') 

scatter(stats(2).EulerNumber, stats(2).area, a, 'r', 'filled') 
scatter(stats(2).mean_EulerNumber, stats(2).mean_area, 20, 'r', 'filled') 

scatter(stats(3).EulerNumber, stats(3).area, a, 'm', 'filled') 
scatter(stats(3).mean_EulerNumber, stats(3).mean_area, 20, 'm', 'filled')

xlabel('EulerNumber', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of EulerNumber vs Area', 'fontsize', 14);
hold off;





% Extent vs Area Scatter Plot
figure(6)
hold on;
a = 10;
scatter(stats(1).Extent, stats(1).area, a, 'g', 'filled') 
scatter(stats(1).mean_Extent, stats(1).mean_area, 20, 'g', 'filled') 

scatter(stats(2).Extent, stats(2).area, a, 'r', 'filled') 
scatter(stats(2).mean_Extent, stats(2).mean_area, 20, 'r', 'filled') 

scatter(stats(3).Extent, stats(3).area, a, 'm', 'filled') 
scatter(stats(3).mean_Extent, stats(3).mean_area, 20, 'm', 'filled')

xlabel('Extent', 'fontsize', 10);
ylabel('Area', 'fontsize', 10);
% legend('Class J', 'Class O', 'Class B');
title('Scatter Plot of Extent vs Area', 'fontsize', 14);
hold off;

% figure(1)
% hold on;
% plot(classJ(1).EquivDiameter:classJ(25).EquivDiameter, 
  % classJ(1).index:classJ(25).index, 'ok')


% figure(1)
% hold on;
% imshow(classJ(:,:,4));

% B = bwboundaries(classJ(:,:,4));
% boundary = B{1};
% fcc = fchcode(boundary);

% s = regionprops(classJ(:,:,4), 'Area', 'FilledArea', 'Perimeter')

% EquivDiameter = sqrt(4 * s.Area / pi)

% for k=1:length(B),
%     boundary = B{k};
%     if(k > N)
%         plot(boundary(:,2),...
%             boundary(:,1),'g','LineWidth',2);
%     else
%         plot(boundary(:,2),...
%             boundary(:,1),'r','LineWidth',2);
%     end
% end
