#filter function, it is affected of semantics problem between scicos and octave

function [res] = Filter(data, cutfreq)
  
  tm = data(:, 1) ./ 1000;
  timebase = tm(1);
  tm =  tm - timebase;
  pos = data(:, 2);
  
  s = getspeed(tm, pos);
  H = buttfilter(cutfreq);
  filtered = csim(s', tm, H);
  res = [tm , filtered'];

endfunction


function res = getspeed(t, p)

  res=[];
  res(1) = 0;
  
  for i = 2:length(t)
    speed_st = t(i) - t(i-1);
    if speed_st == 0 then 
      disp(i); 
      end;
    res(i) = ( 2 * ( p(i) - p(i-1)) - speed_st * res(i-1)) / speed_st;
  end
  
endfunction


function res = buttfilter(cut_freq)

  [pols,gain] = zpbutt(2, cut_freq);
  res = gain / real(poly(pols,'s'));

endfunction
