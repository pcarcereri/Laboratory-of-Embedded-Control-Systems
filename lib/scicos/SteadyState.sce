function [steadystate] = SteadyState (response, window_size)
    steadystate = mean(response($ - window_size : $));
endfunction
