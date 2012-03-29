clc;

// Simply copy&pasted from professor lol

// Motor parameters (change at your will)
K = 2;
Omega_n = 10;
Csi = 0.5;

// Transfer function
s = poly(0, 's');
G = K / (s^2 / Omega_n^2 + 2 * Csi / Omega_n * s + 1);
G = syslin('c', G);

Dt = 0.1;
t = [0:Dt:10];
// Amplitude:
A = 2.5;

u = [zeros(1, round(1/Dt)), A * ones(1, length(t) - round(1/Dt))];
y = csim(u, t, G);

// 1. Sinusoidal input for frequency
// 2. Try getting gains and phases for each frequency

// Code from professor

t0 = 1;
Dt = 0.01;
t = [0:Dt:15];
Ind = find(t > 0);  // Index in which the time is greater than 10sec.
a = 2;

// Note, need to be beyond the transient in order to do correct estimation

SOmega = [0:0.1:3];
GainG = zeros(1, length(SOmega));
PhaseG = zeros(1,length(SOmega));
for i = 1:length(SOmega)
    omega = 10^SOmega(i);
    u = [zeros(1,floor(t0/Dt)), a * sin(omega * (t(floor(t0/Dt) + 1:$) - t0))];
    y = csim(u, t, G);
end
return;

// see bode function: `bode`

