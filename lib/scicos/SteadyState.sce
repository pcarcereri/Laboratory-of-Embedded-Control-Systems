// steady state method, it takes the row value and a windows size

function [steadystate] = SteadyState (response, window_size)

  reslen = length(response); 	//lenght of row value
  v = response(reslen - window_size : reslen); //vector of the *last* values 
  steadystate = mean(v); 	//mean squared error of the last values   

// need to -> calcolare anche la varianza e vedere < tot ok, 
endfunction
