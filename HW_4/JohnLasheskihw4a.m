%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw4a.m
% November 18, 2014
%
% Create a siple function to compute the retinal height of an object under observation and
% test the function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function r = retinal_height(linear_size, distance, nodal_distance)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        retinal_height(linear_size, distance, nodal_distance)
%
%        Compute the retinal height of an object that is linear_size tall and 
%        distance far away. The retinal height is returned in mm units.
%
%        linear_size = Height of object being observed, entered in meters
%        distance: distance from object being observed, entered in meters
%        nodal_distance: distance between lens and retina, entered in mm
%        
%        Author: John Lasheski
function r = retinal_height(linear_size, distance, nodal_distance)
  r = linear_size / distance * nodal_distance;
end

r = retinal_height(20, 75, 16)
printf("The retinal height of a 20m flag at a distance of 17m is %f mm.\n", r);

