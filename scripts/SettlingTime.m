#function settling tim, it takes the time and value rows, the ss and the epsilon in which to calibrate the range

function [settlingtime] = SettlingTime (timestamps, response, steadystate, epsilon)
  
  #trovo l'indice massimo ovvero l'ultimo istante in cui il valore è sopra la soglia
  indUP = max(find(response > steadystate * (1 + epsilon)) );

  #trovo l'indice massimo ovvero l'ultimo istante in cui il valore è sotto la soglia
  indDOWN = max( find(response < steadystate * (1 - epsilon)) );
  
  #settling time
  settlingtime = timestamps(max(indUP,indDOWN));

endfunction
