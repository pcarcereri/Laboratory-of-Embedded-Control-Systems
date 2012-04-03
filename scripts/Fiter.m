# error in the syntax and for me it's difficult to understand what it does, i only know that it works!

#this is what i adapted from the commented code at the bottom
function res = Filter(data, cutfreq)
  
  tm = data(:, 1) ./ 1000;
  timebase = tm(1);
  tm =  tm - timebase;
  pos = data(:, 2);
  
  s=[];
  s(1) = 0;
  for i = 2:length(tm)
    speed_st = tm(i) - tm(i-1);
    if (speed_st == 0) then 
      disp(i); 
      end;
    s(i) = ( 2 * ( pos(i) - pos(i-1)) - speed_st * s(i-1)) / speed_st;
  end

  
  cutfrequency=100;
  [pols,gain] = zpbutt(2, cut_freq);
  H = gain / real(poly(pols,'s'));

  filtered = csim(s', tm, H);

  res = [tm , filtered'];



# ORIGINAL CODE

#{
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


	function res = filter(data, cutfreq)
	  
	  tm = data(:, 1) ./ 1000;
	  timebase = tm(1);
	  tm =  tm - timebase;
	  pos = data(:, 2);
	  
	  s = getspeed(tm, pos);
	  H = buttfilter(cutfreq);
	  filtered = csim(s', tm, H);
	  res = [tm , filtered'];

	endfunction


}#


