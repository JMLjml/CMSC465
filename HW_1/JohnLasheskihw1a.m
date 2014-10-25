%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw1a.m
% October 19, 2014

% Simple script file for generating and plotting two sine waves

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% These will be discrete representations of sine waves

% Set the sampling frequency (how many samples to take)
fs = 100;

% Set the sample rate Ts (time between samples)
Ts = 1/fs;

% create the vector of sample points for the waves for a total of 1 second
n=[0:Ts:1];

% Set the frequencies for X_1 and X_2 in hertz
ft_1 = 1;
ft_2 = 2;

% Set the phases(phi) for X_1 and X_2 in radians
phi_1 = 0;
phi_2 = pi/2;

% Set the amplitude for X_1 and X_2
amplitude_1 = 1;
amplitude_2 = 2;

% Generate the sinewaves for X_1 and X_2
X_1 = amplitude_1 * sin(2 * pi * ft_1 * n + phi_1);
X_2 = amplitude_2 * sin(2 * pi * ft_2 * n + phi_2);

% Plot the waves
plot(n,X_1,n,X_2);
legend('X_1 = sin(2*pi*1*t) (Blue)', 'X_2 = 2*sin(2*pi*2*t + pi/2) (Green)');
title('Two Simple Sine Waves', 'fontsize', 22);
xlabel('time t in seconds', 'fontsize', 16);
ylabel('amplitude', 'fontsize', 16);