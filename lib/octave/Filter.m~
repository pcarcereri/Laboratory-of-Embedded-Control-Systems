function [res] = Filter(data, cut_freq)
  
  tm = data(1,:) ./ 1000;  #converte il timestamp
  timebase = tm(1);  #prende il primo valore
  tm =  tm - timebase; #togli il primo
  pos = data(2,:);
  
  s = getspeed(tm, pos);

  [pols,gain] = butter(2,cut_freq);


  H = gain / real(poly(pols,'s'));

  filtered = csim(s,tm,H); #errore -> '
  res = [tm , filtered'];

endfunction



function [res] = getspeed(t, p)

  res=[];
  res(1) = 0;
  
  for i = 2:length(t)
    speed_st = t(i) - t(i-1);
    if speed_st == 0  
      disp(i); 
      end;
    res(i) = ( 2 * ( p(i) - p(i-1)) - speed_st * res(i-1)) / speed_st;
  end
  
endfunction





