#settling time method, il takes the timestamps and value rows,the ss and a given epsilon

function [settlingtime] = SettlingTime (timestamps,response, steadystate, epsilon)
  
  #max index where the value is above the thresold (ss+ epsilon perchentage)
  x = response > steadystate * (1 + epsilon);
  y = find(x);  #index of non zero elements whose response is > ...
  indUP = max(y);

  #max index where the value is below the thresold (ss+ epsilon perchentage)
  z= response < steadystate * (1 + epsilon);
  w = find(z);
  indDOWN = max(w);
  
  #settling time given by the value of the time vector between the indexes
  settlingtime = timestamps(max(indUP,indDOWN));

endfunction
