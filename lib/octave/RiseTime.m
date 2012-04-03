#risetime function, it takes the time and response rows, the steady state and the min/max perchentage

function [risetime] = RiseTime (time, response, steadystate, maxRaisePerc, minRaisePerc )
  #start and stop are the time value where the response are above or below a given perchengage of the steady state
  start = time( min( find(response > steadystate * minRaisePerc) ) );
  stop = time( min( find(response > steadystate * maxRaisePerc) ) );
  #to get the time interval
  risetime = stop-start;
endfunction
