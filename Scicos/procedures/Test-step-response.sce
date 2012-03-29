// WARNING: THIS IS STILL INCOMPLETE
//
// Working on the fact we have repetitions in time, so we get null intervals
// and divide-by-zero errors by consequence.

loadmatfile('Data', '-ascii');
xs = Data(1,:);
ys_raw = Data(2,:);

exec "./Scicos/lib/NumDerive.sce"
exec "./Scicos/lib/WinAvgFilter.sce"

winsize = 5;
ys_smooth = WinAvgFilter(ys_raw, winsize);

xs = xs(1:$-winsize+1);
xs(2:$) - xs(1,$-1);

[xs,der_ys] = NumDerive(xs, ys_smooth);

plot(xs, der_ys)
