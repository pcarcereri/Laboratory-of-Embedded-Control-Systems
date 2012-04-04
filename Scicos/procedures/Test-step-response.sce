// WARNING: THIS IS STILL INCOMPLETE
//
// Working on the fact we have repetitions in time, so we get null intervals
// and divide-by-zero errors by consequence.

libdir = "../lib/scicos/";
exec (libdir + "NumDerive.sce");
exec (libdir + "WinAvgFilter.sce");
exec (libdir + "Filter.sce");

filename = 'Raw_p060_000';

loadmatfile(filename, '-ascii');
raw = eval(filename);
der = NumDerive(raw);
ders = filter(der, 6);

plot(ders(1,:), ders(2,:), 'r');
