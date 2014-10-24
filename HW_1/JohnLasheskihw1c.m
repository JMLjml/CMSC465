%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% John Lasheski
% JohnLasheskihw1c.m
% October 19, 2014


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set the sampling frequency (how many samples to take)
fs = 20;

% Set the sample rate Ts (time between samples)
Ts = 1/fs;

% create the vector of sample points for the waves for a total of 1 second
n=[0:Ts:1];


%%%%%%%%%%%%%%%%%%%%%%%%%
%Need to fix and comment this better
function p = triangle_pulse(t, delay, A)
	N = length(t);
	p = zeros(1,N);

	
	index = int32(N - delay);


	for i = (delay+1):int32(index/2 + delay + 1)
		p(i) = (i-delay)*A * (2/N);
	end

	for i = int32(index/2+delay):N
		p(i) = (N-i) * A * (2/N);
	end
end 	



function h = moving_average(v,weight)
	N = length(v);
	h = zeros(1,N);

	sum = 0;

	for i = 1:N
		
		for k = 1:(weight)
			if i > k
			    sum += v(i-k);
			end
		end

		h(i) = (1/weight)*sum;

		sum = 0;

	end
end



plot(n,triangle_pulse(n,3,1), n, moving_average(triangle_pulse(n,3,1),5), n, abs(sin(2*pi*n)), n, moving_average(abs(sin(2*pi*n)),5));	
