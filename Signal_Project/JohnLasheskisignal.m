%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw2.m
% November 09, 2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Define some of the test data up here
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read in the data from the Signal files and store them in vectors
Signal1 = 'Signal1.csv';
Signal2 = 'Signal2.csv';
Signal3 = 'Signal3.csv';

S1 = csvread(Signal1);
S2 = csvread(Signal2);
S3 = csvread(Signal3);

% compute and store the length of each set of data
L1 = length(S1);
L2 = length(S2);
L3 = length(S3);


% Set the sampling frequency (how many samples to take)
fs = 1024;

% Set the sample rate Ts (time between samples)
Ts = 1/fs;

% create the vector of sample points for the waves and calculate how long the samples are for each set of data
% need to subtract 1 sample point from  the vector length to account for the fact that we start at 0 rather than 1
n1=[0:Ts:((L1/fs) - (1/fs))];
n2=[0:Ts:((L2/fs) - (1/fs))];
n3=[0:Ts:((L3/fs) - (1/fs))];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Build the variuos plots for the assignment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 1: Plot the input data from the Signal files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1);
hold on;

% Signal 1
subplot(221);   
plot(n1, S1, 'color', 'm');
xlabel('n', 'fontsize', 10);
ylabel('S(n)', 'fontsize', 10);
legend('Signal 1');
title('Signal 1');

% Signal 2
subplot(222);
plot(n2, S2, 'color', 'y');
xlabel('n', 'fontsize', 10);
ylabel('S(n)', 'fontsize', 10);
legend('Signal 2');
title('Signal 2');

% Signal 3
subplot(212);
plot(n3, S3, 'color', 'b');
xlabel('n', 'fontsize', 10);
ylabel('S(n)', 'fontsize', 10);
legend('Signal 3');
set(gca, 'xlim', [0, 3.004]);
title('Signal 3');

hold off;