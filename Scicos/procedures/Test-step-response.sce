// WARNING: THIS IS STILL INCOMPLETE
//
// Working on the fact we have repetitions in time, so we get null intervals
// and divide-by-zero errors by consequence.

libdir = "./../../lib/scicos/";
exec (libdir + "NumDerive.sce");
exec (libdir + "WinAvgFilter.sce");
exec (libdir + "Filter.sce");
exec (libdir + "Overshoot.sce");
exec (libdir + "SteadyState.sce");
exec (libdir + "SettlingTime.sce");
exec (libdir + "Csi.sce");
exec (libdir + "Frequency.sce");
exec (libdir + "RiseTime.sce");

filename = 'Data_m050_000';

loadmatfile(filename, '-ascii');
raw = eval(filename);
der = NumDerive(raw);
ders = WinAvgFilter(der, 6);
ders=abs(ders);

plot(ders(1,:), ders(2,:), 'r');

ss=SteadyState(ders(2,:),200)
o=Overshoot(ders(2,:),ss)
st=SettlingTime(ders(1,:),ders(2,:),ss,0.01) 
rt=RiseTime(ders(1,:),ders(2,:),ss,0.9,0.1)

csi=Csi(ders(2,:),o)
w=Frequency(ders(1,:),ders(2,:),o,csi)




