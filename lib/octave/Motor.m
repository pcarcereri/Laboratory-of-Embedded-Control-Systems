function [res] = Motor(data)
   ks=0;
   ss = SteadyState(data(1,:),data(2,:), 200)
   rt = RiseTime(data(1,:),data(2,:), ss, 0.9, 0.1)
   st = SettlingTime(data(1,:),data(2,:), ss, 0)
   o = Overshoot(data(2,:), i)
   #y = [y; y_vector(tr, ts, ovs)];
   #ks = [ss/i; ks];
   #A = [A;a];

endfunction