#overshoot function
function [overshoot] = Overshoot(response, step)
  peak = max(response); # finds the peack of the response (2nd line)
  overshoot = (peak - step) / step;  #overshoot given by the professor formula 
endfunction


