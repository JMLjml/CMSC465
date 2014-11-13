%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskisignal.m
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
N = 1024;

% Set the sample rate Ts (time between samples)
Ts = 1/fs;

% create the vector of sample points for the waves and calculate how long the samples are for each set of data
% need to subtract 1 sample point from  the vector length to account for the fact that we start at 0 rather than 1
n1=[0:Ts:((L1/fs) - (1/fs))];
n2=[0:Ts:((L2/fs) - (1/fs))];
n3=[0:Ts:((L3/fs) - (1/fs))];



function signal = strip_DC(signal)
    DC_Component = mean(signal);
    signal = signal - DC_Component;
end




function db = pow2db(signal)
    db = 10 * log10(signal);
end



function plotWelch(signal, signal_length, N, fs, figure_count, fftRange, welchRange)

    % Produce a Hanning Window of the correct length
    window = hanning(N);
    
    % Strip out the DC component
    signal = strip_DC(signal);

    % Divide each signal into 1 second intervals
    first = signal(1:N);
    second = signal(N + 1:2 * N);
    third = signal((2 * N)+1:3 * N);

    figure(figure_count);
    hold on;

    viewrange = (1:welchRange);

    % plot the regular FFT for comparison purposes
    subplot(221);
    y = fft(signal, signal_length);
    y0 = fftshift(y);
    f0 = (-signal_length/2:signal_length/2-1)*(fs/signal_length);
    power0 = y0.*conj(y0)/signal_length;
    plot(f0,power0);
    set (gca, 'xlim', [-fftRange, fftRange])
    set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
    set (gca, 'ylabel', 'Power Spectral Value', 'fontsize', 10);
    grid on;

    % plot the 1st second of data using Welch's method
    subplot(222);
    pxx = pwelch(first, window, 0.5, N, fs, 'linear');
    plot(viewrange, pxx(viewrange), 'color', 'm', 'linewidth', 2);
    set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
    set (gca, 'ylabel', 'Power Spectral Value', 'fontsize', 10);
    grid on;

    % plot the 2nd second of data using Welch's method
    subplot(223);
    pxx = pwelch(second, window, 0.5, N, fs, 'linear');
    plot(viewrange, pxx(viewrange), 'color', 'y', 'linewidth', 2);
    set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
    set (gca, 'ylabel', 'Power Spectral Value', 'fontsize', 10);
    grid on;

    % plot the 3rd second of data using Welch's method
    subplot(224);
    pxx = pwelch(third, window, 0.5, N, fs, 'linear');
    plot(viewrange, pxx(viewrange), 'color', 'g', 'linewidth', 2);
    set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
    set (gca, 'ylabel', 'Power Spectral Value', 'fontsize', 10);
    grid on;
    hold off;
end


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
plot(n1, strip_DC(S1), 'color', 'm');
xlabel('n', 'fontsize', 10);
ylabel('S(n)', 'fontsize', 10);
legend('Signal 1');
title('Signal 1');

% Signal 2
subplot(222);
plot(n2, strip_DC(S2), 'color', 'y');
xlabel('n', 'fontsize', 10);
ylabel('S(n)', 'fontsize', 10);
legend('Signal 2');
title('Signal 2');

% Signal 3
subplot(212);
plot(n3, strip_DC(S3), 'color', 'b');
xlabel('n', 'fontsize', 10);
ylabel('S(n)', 'fontsize', 10);
legend('Signal 3');
set(gca, 'xlim', [0, 3.004]);
title('Signal 3');

hold off;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 2, 3 and 4: Plot the FFT and individual Welch FFT's for Signals 1, 2 and 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% FIGURE 2: Plot the FFT and individual Welch FFT's for Signal 1
plotWelch(S1, L1, N, fs, 2, 100, 60);

% FIGURE 3: Plot the FFT and individual Welch FFT's for Signal 2
plotWelch(S2, L1, N, fs, 3, 150, 200);

% FIGURE 4: Plot the FFT and individual Welch FFT's for Signal 3
plotWelch(S3, L1, N, fs, 4, 200, 200);