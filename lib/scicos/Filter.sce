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

  [pols,gain] = zpbutt(5, cut_freq);
  res = gain / real(poly(pols,'s'));

endfunction


function res = filter(data, cutfreq)

  data = data';

  tm = data(:, 1) ./ 1000;
  timebase = tm(1);
  tm =  tm - timebase;
  pos = data(:, 2);

  s = getspeed(tm, pos);
  H = buttfilter(cutfreq);
  filtered = csim(s', tm, H);
  res = [tm , filtered'];

endfunction


//  for i = 10:5:100
//    disp("filtering step " + string(i));
//    data = read("data_step/step" + string(i) + ".mat", -1, 2);
//    filtered = filter(data, 8);
//    plot(filtered(:,1), filtered(:,2));
//    save("data_step/step_filtered" + string(i), filtered);
//  end

//for i = 20:10:400
//    disp("filtering osc " + string(i));
//    data = read("data_osc/osc" + string(i) +".mat", -1, 2);
//    filtered = filter(data, 8);
//    plot(filtered(:,1), filtered(:,2));
//    save("data_osc/osc_filtered" + string(i), filtered);
//  end
//
//for i = 10:10:300
//    disp("filtering osc " + string(i));
//    data = read("data_osc/osc" + string(i) +".mat", -1, 2);
//    filtered = filter(data, 30);
//    plot(filtered(:,1), filtered(:,2));
//    save("data_osc/osc_filtered" + string(i), filtered);
//  end
