// WARNING: THIS IS STILL INCOMPLETE
//
// Working on the fact we have repetitions in time, so we get null intervals
// and divide-by-zero errors by consequence.

filename = 'Data_030';
loadmatfile(filename, '-ascii');
raw = eval(filename);

exec "./Scicos/lib/NumDerive.sce"
exec "./Scicos/lib/WinAvgFilter.sce"

winsize = 5;
smooth = WinAvgFilter(raw, winsize);

der = NumDerive(smooth);

plot(raw(1,:), raw(2,:));
