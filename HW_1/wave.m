% Usage: 
%        wave(ft, phi, amplitude, n)
%
%        The wave function returns a vector of n data points corresponding to the 
%        sin wave genrated by ft, phi, and amplitude.
%
%        ft: frequency in hertz
%        phase: phi
%        amplitude: amplitude
%        n: sample index vector. This is a vector like n = [0:.01:1].
%        This will look at this wave every 100th of a second for 1 second
%
%        Author: John Lasheski
%        Date: October 17, 2014


function retval = wave(ft, phi, amplitude, n)

	a = amplitude * sin(phi);
	b = amplitude * cos(phi);

    %set the angular frequency w=2*pi*ft in radians/second
	omega = 2 * pi * ft;

	retval = (a * cos(omega * n)) + (b * sin(omega * n));
end