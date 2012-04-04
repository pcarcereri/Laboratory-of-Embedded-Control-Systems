#risetime function, it takes the time and response rows, the steady state and the percentage of steadystate variation

function risetime = RiseTime (time, response, steadystate, maxRaisePerc, minRaisePerc )
  #finds in the time row the min value where the response are %minRaisePerc the steady state
  start = time( min( find(response > steadystate * minRaisePerc) ) ); 

  #finds in the time row the min value where the response are %manRaisePerc the steady state
  stop = time( min( find(response > steadystate * maxRaisePerc) ) );

  # time where the value reaches the max% - value where it reaches the %min
  risetime = stop-start;

endfunction
