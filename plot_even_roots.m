%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function plot_even_roots(n)
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Usage: 
%        plot_roots(n)
%
%        Plots the roots of unity up to level n.
%        Creates a separate figure for each plot and labels the primitive root.
%
%        Calls the roots_of_unity function to generate the roots for plotting
%
%        n: power of nth roots to generate
%
%        Author: John Lasheski
%        Date: November 10, 2014
function plot_even_roots(n)

    
    for i = 2:2:n
        figure(i);
        hold on;

        r = roots_of_unity(i, false);

        for k = 2:2:i
            % Polt the primitive root diferent so we can tell it apart
            if k == 1
                polar(angle(r(k)), abs(k), 'db');
            else
    
                % plot each root
                polar(angle(r(k)), abs(r(k)), 'pr');
            end
        end

        label = strcat('nth even roots of unity, n = ', int2str(i));
        legend('Primitive Root');
        title(label, 'fontsize', 14);
        set (gca, 'ylim', [-1.5 1.5]);
        set (gca, 'xlim', [-1.5 1.5]);
        grid on;
        hold off;

    
    end
end
