// WARNING: THIS IS STILL INCOMPLETE
//
// Working on the fact we have repetitions in time, so we get null intervals
// and divide-by-zero errors by consequence.

libdir = "./../lib/scicos/";
exec (libdir + "NumDerive.sce");
exec (libdir + "WinAvgFilter.sce");
exec (libdir + "Filter.sce");
exec (libdir + "Overshoot.sce");
exec (libdir + "SteadyState.sce");
exec (libdir + "SettlingTime.sce");
exec (libdir + "Xsi.sce");
exec (libdir + "Frequency.sce");
exec (libdir + "RiseTime2.sce");

raw_data_path = './';

for ridx = [1:size(Raw_meta, 1)]

    pow = Raw_meta(ridx, 1);
    nexp = Raw_meta(ridx, 2);

    if (pow >= 0)
        sign_name = 'p';
    else
        sign_name = 'm';
    end

    for e = [0:nexp-1]
        filename = sprintf('Raw_%c%03d_%03d', sign_name, abs(pow), e);
        loadmatfile(raw_data_path + filename, '-ascii');
        raw = abs(eval(filename));
        der = NumDerive(raw);
        ders = WinAvgFilter(der, 50);

        plot(ders(1,:), ders(2,:));

//        ss=SteadyState(ders(2,:),200);
//        rt=RiseTime(ders, ss, 0.9, 0.1);
//        printf("raise time for pow=%d: %d\n", pow, rt);

    end

end

//P1 = - log(1/(10 * exp(rt)));
//s = poly(0, 's');
//G = 1/(s + P1);

