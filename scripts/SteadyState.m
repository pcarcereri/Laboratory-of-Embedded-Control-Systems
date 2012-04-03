#steady state function, it takes the value rows and the windows size

function [steadystate] = SteadyState (response, window_size)
  reslen = length(response); #get the lenght of the value row
  v = response(reslen - window_size : reslen); #take the vector from the winsize to the lenght
  steadystate = mean(v); #do the minimum squared error
endfunction
