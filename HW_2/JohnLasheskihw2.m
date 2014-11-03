%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw2.m
% November 02, 2014
%
% Contains functions for computing the DFT, Inverse DFT and for displaying the Maginutde and phase after computing the DFT.
% Generates graphs of discrete and continuous signals and then runs DTT and Inverse_DFT on them to compare the results.
% Output 6 figures showing plots of variuos tests as well as outputting 2 matrices to the terminal displaying the Maginuted and Phase of the DFT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Define some of the test data up here so this is read as a script file, rather than as a function file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the sampling frequency (how many samples to take)
fs = 8000;

% Set the sample rate Ts (time between samples)
Ts = 1/fs;

% create vectors of sample points for the waves
n_continuous=[0:Ts:7];
n_discrete = [0:1:7];

% Set the frequencies for X_1, X_2, and X_3 in hertz
ft_1 = 2000;
ft_2 = 1000;
ft_3 = 1000;

% Set the phases(phi) for X_1, X_2, and X_3 in radians
phi_1 = 0;
phi_2 = pi/4;
phi_3 = ((-3)*pi)/4;

% Set the amplitude for X_1, X_2, and X_3
amplitude_1 = 1;
amplitude_2 = 0.6;
amplitude_3 = 0.2;

% Generate the discrete sinewaves for X_1, X_2, X_3, and Signal
X_1 = amplitude_1 * sin(2 * pi * ft_1 / fs * n_discrete + phi_1);
X_2 = amplitude_2 * sin(2 * pi * ft_2 / fs * n_discrete + phi_2);
X_3 = amplitude_3 * sin(2 * pi * ft_3 / fs * n_discrete + phi_3);
Signal = X_1 + X_2 + X_3;

% Generate the composite sinewaves for C_1, C_2, C_3 and C_Signal
C_1 = amplitude_1 * sin(2 * pi * ft_1 / fs * n_continuous + phi_1);
C_2 = amplitude_2 * sin(2 * pi * ft_2 / fs * n_continuous + phi_2);
C_3 = amplitude_3 * sin(2 * pi * ft_3 / fs * n_continuous + phi_3);
C_Signal = C_1 + C_2 + C_3;

% Generate the m Sinusoids
MS_1 = sin(2 * pi * 1000 / fs * n_continuous);
MS_2 = sin(2 * pi * 2000 / fs * n_continuous);
MS_3 = sin(2 * pi * 3000 / fs * n_continuous);
MC_1 = cos(2 * pi * 1000 / fs * n_continuous);
MC_2 = cos(2 * pi * 2000 / fs * n_continuous);
MC_3 = cos(2 * pi * 3000 / fs * n_continuous);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function X = DFT(x_t)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        DFT(x_t)
%
%        Compute the Discrete Fourier Transform on signal x_t
%        
%        Author: John Lasheski
%        Date: November 02, 2014
function X = DFT(x_t)
	N = length(x_t);
	X = zeros(1,N);
	DFT = 0;
	
	% Store the complex results in vector X
	for k = 0:N-1

		for n = 0:N-1
			DFT += x_t(n+1)*e^(-j * 2 * pi * n * k / N);
			n++;
		end
		X(k+1) = DFT;
		DFT = 0;	
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function M = DFT_Convert(X)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        DFT_Convert(X)
%
%        Compute the magnitude and phase from Vector X created by running Discrete Fourier Transform on signal x_t
%        
%        Author: John Lasheski
%        Date: November 02, 2014
function M = DFT_Convert(X)
	N = length(X);
	M = zeros(N-1,3); % Will be used to store M, Magnitude, and phase data
	tol=1e-10; % Used to zero out small results

	% Convert the complex results into Magnitude and phase, store the in Matrix M
	for k = 0:N-1

		rt = real(X(k+1));
		it = imag(X(k+1));
		if ( abs(rt) < tol)
    		rt = 0;
		end   
	
		if (abs(it) < tol)
  			it = 0;
		end   

		final=complex(rt,it);

		M(k+1,1) = k;

		% Assuming final is the X(m) then this gives you the magnitude:
		M(k+1,2) = mag=abs(final);
		% And this gives you the phase in degrees
		M(k+1,3) = phase=angle(final)*180/pi;
	end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function x_t = Inverse_DFT(X)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        Inverse_DFT(X)
%
%        Compute the inverse DFT on Vector X to get back the orignial signal x_t
%        
%        Author: John Lasheski
%        Date: November 02, 2014
function x_t = Inverse_DFT(X)
	N = length(X);
	DFT = 0;
	
	for n = 0:N-1

		for k = 0:N-1
			DFT += (1/N) * X(k+1)*e^(j * 2 * pi * n * k / N);
			k++;
		end
		x_t(n+1) = real(DFT);
		DFT = 0;	
	end
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Create the DFT Arrarys for M, Magnitude and Phase
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Run the DFT on the original signal
X = DFT(Signal);
M = DFT_Convert(X);

% run the DFT on the shifted Signal
Shift_Signal = shift(Signal,5); % Shift the DFT vector by 5
Shift_X = DFT(Shift_Signal);
Shift_M = DFT_Convert(Shift_X);

% Run the inverse DFT on X to get back the original signal
Inverse_X = Inverse_DFT(X);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Build the variuos plots for the assignment
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 1: Discrete Points and the continuous waves
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Plot the discrete points and the continuous waves
figure(1);
hold on;
% Plot the discrete points
stem(n_discrete, X_1, 'color', 'b', 'marker', '+', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');
stem(n_discrete, X_2, 'color', 'g', 'marker', 'o', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');
stem(n_discrete, X_3, 'color', 'r', 'marker', 'x', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');
stem(n_discrete, Signal, 'color', 'c', 'marker', 'v', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');

% Plot the continuous waves
plot(n_continuous, C_1, 'color', 'm');
plot(n_continuous, C_2, 'color', 'y');
plot(n_continuous, C_3, 'color', 'k');
plot(n_continuous, C_Signal, 'color', 'b');

% Set options for Figure 1
set (gca, 'ylim', [-1.5 1.5]);
xlabel('n', 'fontsize', 10);
ylabel('x(n)', 'fontsize', 10);
legend('X_1', 'X_2', 'X_3', 'Signal', 'C_1', 'C_2', 'C_3', 'CSignal');
title('Components and Input Signal', 'fontsize', 14);
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 2: M = 1 Sinusoids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2)
hold on;
% Plot the discrete points
stem(n_discrete, Signal, 'color', 'b', 'marker', 'v', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');

% Plot the continuous waves
plot(n_continuous, MS_1, 'color', 'g');
plot(n_continuous, MC_1, 'color', 'r');
plot(n_continuous, C_Signal, 'color', 'c');

% Set options for Figure 2
set (gca, 'ylim', [-1.5 1.5]);
xlabel('n', 'fontsize', 10);
ylabel('x(n)', 'fontsize', 10);
legend('Signal', 'sin', 'cos', 'CSignal');
title('Input Signal and m=1 Sinusoids', 'fontsize', 14);
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 3: M = 2 Sinusoids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
hold on;
% Plot the discrete points
stem(n_discrete, Signal, 'color', 'b', 'marker', 'v', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');

% Plot the continuous waves
plot(n_continuous, MS_2, 'color', 'g');
plot(n_continuous, MC_2, 'color', 'r');
plot(n_continuous, C_Signal, 'color', 'c');

% Set options for Figure 3
set (gca, 'ylim', [-1.5 1.5]);
xlabel('n', 'fontsize', 10);
ylabel('x(n)', 'fontsize', 10);
legend('Signal', 'sin', 'cos', 'CSignal');
title('Input Signal and m=2 Sinusoids', 'fontsize', 14);
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 4: M = 3 Sinusoids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(4)
hold on;
% Plot the discrete points
stem(n_discrete, Signal, 'color', 'b', 'marker', 'v', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');

% Plot the continuous waves
plot(n_continuous, MS_3, 'color', 'g');
plot(n_continuous, MC_3, 'color', 'r');
plot(n_continuous, C_Signal, 'color', 'c');

% Set options for Figure 4
set (gca, 'ylim', [-1.5 1.5]);
xlabel('n', 'fontsize', 10);
ylabel('x(n)', 'fontsize', 10);
legend('Signal', 'sin', 'cos', 'CSignal');
title('Input Signal and m=3 Sinusoids', 'fontsize', 14);
hold off;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 5: Original Signal and Shifted Signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(5)
hold on;
% Plot the discrete points
stem(n_discrete, Signal, 'color', 'b', 'marker', 'v', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');
stem(n_discrete, Shift_Signal, 'color', 'g', 'marker', '+', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');


% Plot the continuous waves
plot(n_continuous, C_Signal, 'color', 'c');

% Set options for Figure 5
set (gca, 'ylim', [-1.5 1.5]);
xlabel('n', 'fontsize', 10);
ylabel('x(n)', 'fontsize', 10);
legend('Signal', 'Shift Signal', 'CSignal');
title('Orignal Signal and Shifted Signal', 'fontsize', 14);
hold off;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FIGURE 6: Original Signal and Inverse DFT Signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(6)
hold on;
% Plot the discrete points
stem(n_discrete, Signal, 'color', 'b', 'marker', 'v', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');
stem(n_discrete, Inverse_X, 'color', 'g', 'marker', 'o', 'markersize', 10, 'linestyle', 'none', 'showbaseline', 'off');


% Plot the continuous waves
plot(n_continuous, C_Signal, 'color', 'c');

% Set options for Figure 6
set (gca, 'ylim', [-1.5 1.5]);
xlabel('n', 'fontsize', 10);
ylabel('x(n)', 'fontsize', 10);
legend('Signal', 'Inverse Signal', 'CSignal');
title('Orignal Signal and Inverse DFT Signal', 'fontsize', 14);
hold off;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output the results of the DFT operations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Display the Matrix for the original signal
printf("\n     Output for 8 point DFT \n");
printf("      M      Magnitude      Phase\n");
M

% Display the Matrix for the shifted signal
printf("     Output for Shifted 8 point DFT\n");
printf("      M      Magnitude      Phase\n");
Shift_M