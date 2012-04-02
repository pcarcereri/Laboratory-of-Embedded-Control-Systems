// WARNING: THIS IS STILL INCOMPLETE
//
// Working on the fact we have repetitions in time, so we get null intervals
// and divide-by-zero errors by consequence.

loadmatfile('Data_070', '-ascii');

exec "./Scicos/lib/NumDerive.sce"
exec "./Scicos/lib/WinAvgFilter.sce"

raw = Data_070;

winsize = 5;
smooth = WinAvgFilter(raw, winsize);

der = NumDerive(smooth);

plot(raw(1,:), raw(2,:));
