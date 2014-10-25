%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw1c.m
% October 19, 2014
%
% Creates two functions. The first function generates a triangle impulse wave and the second function
% calculates an n period moving average of a supplied vector/wave.
%
% Sample outputs are plotted
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Define some of the test data up here so this is read as a script file, rather than as a function file

% Set the sampling frequency (how many samples to take)
fs = 58;

% Set the sample rate Ts (time between samples)
Ts = 1/fs;

% create the vector of sample points for the waves for a total of 1 second
n=[0:Ts:1];

% create a test vector called x with data from for5avg.m supplied by instructor
% must be working in the same directory as to where the file for5avg.m is saved
x = dlmread('for5avg.m');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function p = triangle_pulse(t, shift, A)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        triangle_pulse(t, shift, A)
%
%        The triangle_pulse function returns a vector of t data points corresponding to the 
%        triangle pulse wave with amplitude A. It can be shifted left and right.
%
%        t: data point vector
%        shift: positive values move the pulse to the right, negative to the left
%        A: max amplitude of the triangle
%        
%        Author: John Lasheski
%        Date: October 24, 2014
function p = triangle_pulse(t, shift, A)

	N = length(t);
	p = zeros(1,N);

	%set the apex of the triangle and multiple for multiplying Amplitude by
	if(mod(N,2) == 0) % N even
		apex = (N/2);
		multiple = (2/(N-2));
	else
		apex = ((N+1)/2);
		multiple = (2/(N-1));
	end

	% build the ascending part of the triangle
	for i = (shift + 2):(apex + shift)
		if(i >= 1 && i <= N)
			p(i) = (i - 1 - shift) * A * multiple;
		end
	end

	% build the descending part of the triangle
	for i = (shift + apex + 1):(N - 1 + shift)
		if(i >= 1 && i <= N)
			p(i) = (N - i + shift) * A * multiple;
		end
	end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function h = moving_average(v, weight)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        moving_average(v, weight)
%
%        The moving_average function returns a vector corresponding to the simple moving average of 
%        argument vector v. The weight defines the number of points to look at for the average.
%
%        v: data point vector
%        weight: weighting to take for simple moving average
%        
%        Author: John Lasheski
%        Date: October 24, 2014
function h = moving_average(v,weight)
	N = length(v);
	h = zeros(1,N);

	% invalid argument for weight
	if(weight < 1)
		return;
	end

	for i = 1:N
		sum = 0;
				
		for k = 0:(weight - 1)
			if ((i - k) >= 1)
			    sum += v(i-k);
			end
		end

		h(i) = (1/weight) * sum;
	end
end


% plot a triangle impulse wave with its 5 period moving average
subplot(211)
plot(n,triangle_pulse(n,7,1), 'linewidth', 2, n, moving_average(triangle_pulse(n,7,1),5));
set (gca, 'ylim', [-.1 1.1]);
legend('Triangle Pulse t(n,7,1) (Blue)', 'Moving Average(t, 5) (Green)');
xlabel('time t in seconds', 'fontsize', 16);
ylabel('amplitude', 'fontsize', 16);
title('Triangle Impulse Wave with 5 Period Moving Average', 'fontsize', 22);

% plot the supplied vector x with its 5 period moving average
subplot(212)
plot(n, x, 'linewidth', 2, n, moving_average(x, 5));
set (gca, 'ylim', [-.1 1.1]);
legend('X (Blue)', 'Moving Average(X, 5) (Green)');
xlabel('time t in seconds', 'fontsize', 16);
ylabel('amplitude', 'fontsize', 16);
title('Vector X with 5 Period Moving Average', 'fontsize', 22);