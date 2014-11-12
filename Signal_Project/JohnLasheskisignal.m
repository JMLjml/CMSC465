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




S1 = strip_DC(S1);
S2 = strip_DC(S2);
S3 = strip_DC(S3);



% Divide each signal into 1 second intervals
S1_first = S1(1:N);
S1_second = S1(N + 1:2 * N);
S1_third = S1((2 * N)+1:3 * N);

S2_first = S2(1:fs);
S2_second = S2(fs+1:2*fs);
S2_third = S2((2*fs)+1:3*fs);

S3_first = S3(1:fs);
S3_second = S3(fs+1:2*fs);
S3_third = S3((2*fs)+1:3*fs);







% Produce a Hanning Window of the correct length
window = hanning(N);







%{


function pxx = build_pxx(signal, fs, N)
    % Strip out the DC component by taking the mean of the input
    % and subtracting it from the input signal
    % DC_Component = mean(signal);
    % signal = signal - DC_Component;

    % Produce a Hanning Window of the correct length
    window = hanning(N);

    split_signal = zeros((length(signal)/fs),N);

    % split the signal into 1 second intervals
    for i=1:(length(signal)/fs)
        split_signal(i) = signal(((i-1)* N + 1):(i * N));
    end

    % Apply the welch method to create the FFT using windows, assume 50% overlap
    for i=1:(length(signal)/fs)
        pxx(i) = pwelch(split_signal(i), window, 0.5, N, fs, 'linear');
    end

end
%}

%{


% Remove DC offset
S1_firstDC = mean(S1_first);
S1_firstNoDC = S1_first - S1_firstDC;

hann = hanning(fs);

% I added the 0.5 argument - i think this is overlap - maybe window overlap????
pxx = pwelch(S1_firstNoDC, hann, 0.5, fs, fs);

viewrange = 1:128;
plot(viewrange,pxx(viewrange));


%}


% Play around with the FFT function a little

%{
x = sin(2*pi*200*n1);

y = fft(x, L1);

f = (0:L1-1)*(fs/L1);
power = y.*conj(y)/L1;
% plot(f, power);

y0 = fftshift(y);
f0 = (-L1/2:L1/2-1)*(fs/L1);
power0 = y0.*conj(y0)/L1;
plot(f0,power0);

%}


% y = fft(S1,L1);
% y = fft(S1);
% f = (0:L1-1)*(fs/L1);
% power = y.*conj(y)/L1;
% plot(f, ((abs(y).^2)/L1));

%{
y0 = fftshift(y);
f0 = (-L1/2:L1/2-1)*(fs/L1);
power0 = y0.*conj(y0)/L1;
plot(f0,power0);
%}

%{

y = fft(S3,L1);
f = (0:L2-1)*(fs/L2);
power = y.*conj(y)/L2;
plot(f, power);

%}



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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 2: Plot the FFT and individual Welch FFT's for Signal 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2);
hold on;

viewrange = (1:60);

% plot the regular FFT for comparison purposes
subplot(221);
y = fft(S1, L1);
y0 = fftshift(y);
f0 = (-L1/2:L1/2-1)*(fs/L1);
power0 = y0.*conj(y0)/L1;
plot(f0,power0);
set (gca, 'xlim', [-100, 100])
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;


% plot the 1st second of data using Welch's method
subplot(222);
pxx = pwelch(S1_first, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'm', 'linewidth', 2);
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;

% plot the 2nd second of data using Welch's method
subplot(223);
pxx = pwelch(S1_second, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'y', 'linewidth', 2);
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;

% plot the 3rd second of data using Welch's method
subplot(224);
pxx = pwelch(S1_third, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'g', 'linewidth', 2);
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;
hold off;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 3: Plot the FFT and individual Welch FFT's for Signal 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3);
hold on;

viewrange = (1:200);

% plot the regular FFT for comparison purposes
subplot(221);
y = fft(S2, L1);
y0 = fftshift(y);
f0 = (-L1/2:L1/2-1)*(fs/L1);
power0 = y0.*conj(y0)/L1;
plot(f0,power0);
set (gca, 'xlim', [-150, 150])
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;

% plot the 1st second of data using Welch's method
subplot(222);
pxx = pwelch(S2_first, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'm', 'linewidth', 2);
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;

% plot the 2nd second of data using Welch's method
subplot(223);
pxx = pwelch(S2_second, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'y', 'linewidth', 2);
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;

% plot the 3rd second of data using Welch's method
subplot(224);
pxx = pwelch(S2_third, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'g', 'linewidth', 2);
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;
hold off;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 4: Plot the FFT and individual Welch FFT's for Signal 3
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4);
hold on;

viewrange = (1:200);

% plot the regular FFT for comparison purposes
subplot(221);
y = fft(S3, L1);
y0 = fftshift(y);
f0 = (-L1/2:L1/2-1)*(fs/L1);
power0 = y0.*conj(y0)/L1;
plot(f0,power0);
set (gca, 'xlim', [-200, 200])
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;

% plot the 1st second of data using Welch's method
subplot(222);
pxx = pwelch(S3_first, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'm', 'linewidth', 2);
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;

% plot the 2nd second of data using Welch's method
subplot(223);
pxx = pwelch(S3_second, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'y', 'linewidth', 2);
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
grid on;

% plot the 3rd second of data using Welch's method
subplot(224);
pxx = pwelch(S3_third, window, 0.5, N, fs, 'linear');
plot(viewrange, pxx(viewrange), 'color', 'g', 'linewidth', 2);
grid on;
set (gca, 'xlabel', 'Frequency (Hz)', 'fontsize' , 10);
hold off;