#overshoot method, it takes the value rows and the step amplitude
function [overshoot] = Overshoot(response, ss)
  peak = max(response); #find the max in the response row
  overshoot = peak - ss;
endfunction


