// in this method we calculate the period (oscillation between two peaks)
function [frequency] = Frequency(timing,response, overshoot, csi)
  
  resp=response; // duplicazione del vettore
  indov=find(resp==o); //index dell'overshoot
  resp(indov)=[];      // overshoot azzerato
  maxsml=max(resp);    //valore più piccolo dell'over
  indsml=find(resp==maxsml); // index del valore
  period = abs(timing(indov) - timing(maxsml)); // time(overshoot) - time(overshoot--)
  naturalfrequency= 1/period;

  // system frequency
  frequency = naturalfrequency / (sqrt(1-pow(csi,2)));
  

endfunction


