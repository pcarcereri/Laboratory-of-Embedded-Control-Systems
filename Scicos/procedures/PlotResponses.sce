libdir = "./../lib/scicos/";
exec (libdir + "NumDerive.sce");
exec (libdir + "WinAvgFilter.sce");
exec (libdir + "ButterFilter.sce");
exec (libdir + "Filter.sce");
exec (libdir + "Overshoot.sce");
exec (libdir + "SteadyState.sce");
exec (libdir + "SettlingTime.sce");
exec (libdir + "Xsi.sce");
exec (libdir + "Frequency.sce");
exec (libdir + "RiseTime.sce");

raw_data_path = './';
raw_data_filename = 'Raw';

metafilename = sprintf("%s_meta", raw_data_filename);
disp(raw_data_path + metafilename);
loadmatfile(raw_data_path + metafilename, '-ascii');
meta = eval(metafilename);

for ridx = [1:size(meta, 1)]

    pow = meta(ridx, 1);
    nexp = meta(ridx, 2);

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
        ders_bf = ButterFilter(der, 10);
        ders_wn = WinAvgFilter(der, 50);

        plot(ders_bf(1,:), ders_bf(2,:), 'r', ders_wn(1,:), ders_wn(2,:), 'k');
        //plot(ders_wn(1,:), ders_wn(2,:));
        //plot(ders_bf(1,:), ders_bf(2,:));
    end

end

