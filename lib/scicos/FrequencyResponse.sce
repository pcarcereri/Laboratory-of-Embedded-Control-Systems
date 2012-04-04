function res = est_steadystate (timings, speeds, wnd)
  m = length(speeds);
  v = speeds(m - wnd : m);
  res = mean(v);
endfunction


function res = est_risetime (timings, speeds, sstate, maxRaisePerc, minRaisePerc )
  start = timings( min( find(speeds > sstate * minRaisePerc) ) );
  stop = timings( min( find(speeds > sstate * maxRaisePerc) ) );
  res = stop-start;
endfunction


function res = est_overshoot (speeds, step)
  peak = max(speeds);
  res = (peak - step) / step;
endfunction


function res = est_settletime (timings, speeds, sstate, epsilon)
  //trovo l'indice massimo ovvero l'ultimo istante in cui il valore è sopra la soglia
  p1 = max( find(speeds > sstate * (1 + epsilon)) );
  //trovo l'indice massimo ovvero l'ultimo istante in cui il valore è sotto la soglia
  p2 = max( find(speeds < sstate * (1 - epsilon)) );
  //settling time
  res = timings(max(p1, p2));
endfunction


function res = est_delay (measured, sstate)
  start = min(find (measured(:,2) > 0.0002 * sstate));
  res = measured(start, 1) ;
endfunction;


function res = y_vector (rtime, stime, ovs) 
    res = [ -log(rtime) + log(1.8) ; +log(stime) - log(4.6) ; log(sqrt( (log(ovs))^2 / ((%pi)^2 + (log(ovs))^2) )) ];    
endfunction

function res = simulate_motor (power, k, zeta, wn)
  
  time = 0:0.01:10;
  ctrl_fun = ones(1,length(time))*power;
  nom = k * wn^2;
  den =  poly ([wn^2, zeta*wn*2, 1 ], "s", "c" );
  
  resp = csim(ctrl_fun, time, (nom/den));
  res=[time', resp'];
endfunction


function res = clean_delay (data, delay)
  
  r = find(data(:,1) >= delay, 1);
  tmp = data(r:length(data(:,1)), :);
  tmp(:,1) = tmp(:,1) - delay;
  res = tmp;

endfunction

Graphs = list();
A = [];
a = [ 1, 0 ; -1 , -1; 0 , 1 ];
y = [];
ks = [];


for i = 40:5:95
   load("data_step/step_filtered"+string(i));
   
   ss = est_steadystate(filtered(:,1), filtered(:,2), 200);
   tr = est_risetime(filtered(:,1), filtered(:,2), ss, 0.9, 0.1);
   ts = est_settletime(filtered(:,1), filtered(:,2), ss, 0.025);
   ovs = est_overshoot(filtered(:,2), i);
   y = [y; y_vector(tr, ts, ovs)];
   ks = [ss/i; ks];
   A = [A;a];
   
   e.ss = ss;
   e.graph = filtered;
   e.pow = i;
   Graphs($+1) = e;
   
  //disp ("tr="+string(tr));
  //disp ("ovs="+string(ovs));
  //disp ("ts="+string(ts));
   
end

x = %e^(pinv(A)*y);
k = mean(ks);

NGraphs = list();
for e = Graphs
  
  n.pow = e.pow;
  n.graph = e.graph;
  n.ss = e.ss;
  n.sim = simulate_motor(n.pow, k, 0.75, 7.6);
  //n.sim = simulate_motor(n.pow, k, x(2), x(1));
  n.delay = est_delay(n.graph, n.ss);
  e = null();
  NGraphs($+1) = n;
  
end  
    

for e = NGraphs
  
  scf(0);
  xtitle("Risposta al gradino", "Tempo [s]", "Velocita [Deg/s]");
  graph = clean_delay(e.graph, e.delay);
  plot2d(graph(:,1), graph(:,2), style=2);
  plot2d(e.sim(:,1), e.sim(:,2), style=5);
  hl = legend("risposta misurata", "risposta modello");
  xs2eps(0, "steps_resp");
end
  
disp(x);
disp(k);
