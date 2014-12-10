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
  s = regionprops(classJ(i).image, 'Area', 'FilledArea', 'Perimeter');

  classJ(i).B = B;
  classJ(i).boundary = boundary;
  classJ(i).fcc = fcc;
  classJ(i).s = s;
  area = classJ(i).s.Area; % this is stupid
  EquivDiameter = area * 4 / pi;
  classJ(i).EquivDiameter = EquivDiameter;

  i++;
end




for i = 1:25
  B = bwboundaries(classO(i).image);
  boundary = B{1};
  fcc = fchcode(boundary);
  s = regionprops(classO(i).image, 'Area', 'FilledArea', 'Perimeter');

  classO(i).B = B;
  classO(i).boundary = boundary;
  classO(i).fcc = fcc;
  classO(i).s = s;
  area = classO(i).s.Area; % this is stupid
  EquivDiameter = area * 4 / pi;
  classO(i).EquivDiameter = EquivDiameter;

  i++;
end




for i = 1:25
  B = bwboundaries(classB(i).image);
  boundary = B{1};
  fcc = fchcode(boundary);
  s = regionprops(classB(i).image, 'Area', 'FilledArea', 'Perimeter');

  classB(i).B = B;
  classB(i).boundary = boundary;
  classB(i).fcc = fcc;
  classB(i).s = s;
  area = classB(i).s.Area; % this is stupid
  EquivDiameter = area * 4 / pi;
  classB(i).EquivDiameter = EquivDiameter;

  i++;
end




% make another structure here to store all of this stuff


for i = 1:25
  jfccv(i) = sum(classJ(i).fcc.fcc);
  jareav(i) = classJ(i).s.Area;
  i++;
end

jfccmean = mean(jfccv)
jareamean = mean(jareav)


for i = 1:25
  ofccv(i) = sum(classO(i).fcc.fcc);
  oareav(i) = classO(i).s.Area;
  i++;
end

ofccmean = mean(ofccv)
oareamean = mean(oareav)



for i = 1:25
  bfccv(i) = sum(classB(i).fcc.fcc);
  bareav(i) = classB(i).s.Area;
  i++;
end

bfccmean = mean(bfccv)
bareamean = mean(bareav)






figure(1)
hold on;
a = 10;
scatter(jfccv, jareav, a, 'g', 'filled') 
scatter(jfccmean, jareamean, 20, 'g', 'filled') 

scatter(ofccv, oareav, a, 'r', 'filled') 
scatter(ofccmean, oareamean, 20, 'r', 'filled') 

scatter(bfccv, bareav, a, 'm', 'filled') 
scatter(bfccmean, bareamean, 20, 'm', 'filled') 

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
