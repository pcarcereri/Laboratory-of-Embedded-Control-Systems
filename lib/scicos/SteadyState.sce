function [steadystate] = SteadyState (response, window_size)
    steadystate = mean(response(2, $ - window_size : $));
endfunction
