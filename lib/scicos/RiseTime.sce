// rise time function, takes the time and speed rows, the ss and the perchentage range
function [risetime] = RiseTime (timings, response, ss, maxRaisePerc, minRaisePerc )
  start = timings( min( find(response > ss * minRaisePerc) ) ); //min time where speed > ..
  stop = timings( min( find(response > ss * maxRaisePerc) ) );
  risetime = stop-start;
endfunction
