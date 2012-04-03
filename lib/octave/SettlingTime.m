#settling time method, il takes the timestamps and value rows,the ss and a given epsilon

function [settlingtime] = SettlingTime (timestamps, response, steadystate, epsilon)
  
  #max index where the value is above the thresold (ss+ epsilon perchentage)
  indUP = max(find(response > steadystate * (1 + epsilon)) );

  #max index where the value is below the thresold (ss+ epsilon perchentage)
  indDOWN = max( find(response < steadystate * (1 - epsilon)) );
  
  #settling time given by the value of the time vector between the indexes
  settlingtime = timestamps(max(indUP,indDOWN));

endfunction
