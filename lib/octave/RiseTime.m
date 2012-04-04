#risetime function, it takes the time and response rows, the steady state and the min/max perchentage

function [risetime] = RiseTime (time, response, steadystate, maxRaisePerc, minRaisePerc )

  #start and stop are the time value where the response are above or below a given perchengage of the steady state
  x=(response > (steadystate * minRaisePerc));
  y=find(x);
  start = time(min(y));

  w=(response > (steadystate * minRaisePerc));
  x=find(w);
  stop = time(min(x));

  #to get the time interval
  risetime = stop-start;

endfunction

