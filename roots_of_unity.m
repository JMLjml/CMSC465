%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function r = roots_of_unity(n, primitive)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        roots_of_unity(n)
%
%        Returns a complex vector of the nth roots of unity for complex numbers.
%        To generate only the promitive roots set primitive = true
%
%        n: power of nth roots to generate
%        primitive: a boolean value, set to true to only generate the promitive roots of n
%        
%        Author: John Lasheski
%        Date: November 10, 2014
function r = roots_of_unity(n, primitive)
    tol=1e-10; % Used to zero out small results

    % determine if we are only generatong primitive roots or not
    if primitive
        k = 1;
    else
        k = n;
    end

    for i = 1:k
        root = e^(j * 2 * pi * i / n); % find the root


        % set to 0 the numbers less than tol
        rt = real(root);
        it = imag(root);
        if ( abs(rt) < tol)
            rt = 0;
        end   
    
        if (abs(it) < tol)
            it = 0;
        end   

        % store the root in return vector r
        r(i) = complex(rt,it);
    end
end