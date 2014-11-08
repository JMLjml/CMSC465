%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function r = primitive_roots_of_unity(n)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        primitive_roots_of_unity(n)
%
%        Returns a vector of n human readable angles of nth roots of unity for complex numbers.
%       
%        n: power of nth roots to generate
%        
%        Author: John Lasheski
%        Date: November 10, 2014
function r = primitive_roots_of_unity(n)
    for i = 1:n
        r(i,1) = i;
        r(i,2) = (angle(roots_of_unity(i, true)) * 180 / pi);
end