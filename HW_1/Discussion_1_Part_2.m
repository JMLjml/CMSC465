% John Lasheski
% Discussion_1_Part_2.m
% October 19, 2014

clear all;
format long;

% The target atributes of the wave
ft = 3;
A = 1;
phi = pi/2;

% Set the sampling frequency (how many samples to take)
fs = 500;

% Set the sample rate Ts (time between samples)
Ts = 1/fs;

% Show a plot of the sample wave for visual inspection
n = [0:Ts:1];
stem(n,wave(ft,phi,A,n));
title("sin(2*pi*3*t + pi/2)");
xlabel("t in seconds");
ylabel("f(t)");