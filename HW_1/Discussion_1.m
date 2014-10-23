% John Lasheski
% Discussion_1.m
% October 19, 2014

clear all;
format long;

% The target atributes of the wave that we are trying to deduce
ft = 1;
A = 1;
phi = 0;

% Set the sampling frequency (how many samples to take)
% Using 44,000 so the max frequency we can determine accurately will by 22,000 hz
fs = 44000;

% Set the sample rate Ts (time between samples)
Ts = 1/fs;

% count is used to count the number of samples until we find a duplicate value
count = 0;

% error margin - we will not find an exact match due to computer rounding errors
error_margin = 1e-6;

% determine the start_value of the sine wave, this will be 0 unless there is a phase shift
start_value = wave(ft, phi, A, 0);

printf('\nThe start_value we are looking for is: %f\n\n', start_value);

% set found to true once we find a second data point that equals s(0)
found = false;


% sample the sine wave until we reach a value that matches the start value
while (!found)
	count++;
	% if we have a match to start_value, stop counting
	if((wave(ft, phi, A, Ts*count) >= (start_value - error_margin)) && (wave(ft,phi,A,Ts*count) <= (start_value + error_margin)))
		found = true;
	endif
endwhile


% The period of the sinewave equals 2 * count * Ts
T = 2* count * Ts;

printf('We counted %i intervals of size %f.\n\n',count, Ts);
printf('Total elapsed time until a duplicate value was found was %f seconds.\n\n',count*Ts);
printf('Therefore the period of the wave is %f seconds.\n\n',T);
printf('From period T we have the frequency of the wave to be %f hertz.\n\n',1/T);


% Show a plot of the sample wave for visual inspection
n = [0:Ts:1];
plot(n,wave(ft,phi,A,n));