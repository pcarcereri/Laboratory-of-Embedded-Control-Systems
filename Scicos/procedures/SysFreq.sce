libdir = "./../lib/scicos/";
exec (libdir + "NumDerive.sce");
exec (libdir + "WinAvgFilter.sce");
exec (libdir + "ButterFilter.sce");
exec (libdir + "Filter.sce");
exec (libdir + "Overshoot.sce");
exec (libdir + "SteadyState.sce");
exec (libdir + "SettlingTime.sce");
exec (libdir + "Xsi.sce");
exec (libdir + "WinTrend.sce");
exec (libdir + "SystemFrequency.sce");
exec (libdir + "RiseTime.sce");

raw_data_path = './';
raw_data_filename = 'Raw';

ridx = 4;

// LOADING of item of index `ridx`
metafilename = sprintf("%s_meta", raw_data_filename);
loadmatfile(raw_data_path + metafilename, '-ascii');
meta = eval(metafilename);
pow = meta(ridx, 1);
nexp = meta(ridx, 2);
if (pow >= 0)
    sign_name = 'p';
else
    sign_name = 'm';
end

// LOADING of experiment `nexp` for index `ridx`
filename = sprintf('Raw_%c%03d_%03d', sign_name, abs(pow), nexp - 1);
loadmatfile(raw_data_path + filename, '-ascii');
raw = abs(eval(filename));
der = NumDerive(raw);
ders_bf = ButterFilter(der, 10);
stepres = WinAvgFilter(ders_bf, 10);

startstop = [ders_bf(1,1), ders_bf(1,$)];

ss = SteadyState(stepres, 500);
os = Overshoot(stepres, ss);
xi = Xsi(os);
rt = RiseTime(stepres, ss, 0.9, 0.1);

sfreq = SystemFrequency(stepres, rt, xi)
natfreq = sfreq(1);
start = sfreq(2);
stop = sfreq(3);

plot(stepres(1,:), stepres(2,:), 'r', [start,stop], [ss,ss]);
