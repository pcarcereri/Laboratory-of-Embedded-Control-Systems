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
//plot(t, y);

// Gain of the motors:
//    - need to compute steady state value

// Function going ahead on response until the standard deviation is below
// a certain threshold (i.e. 0.01), then return the average of a window in
// that position.
function [steady] = find_steady_idea0 (response)
    
    window_size = 20;
    threshold = 0.01
    
    response_len = size(response, 2)
    
    for i = [1 : (response_len - window_size)],
        buffer = response(i : i + window_size);
        s = stdev(buffer);
        if (s < threshold)
            steady = mean(buffer)
            break;
        end
    end
endfunction

function [steady] = find_steady_idea1 (response)
    window_size = 20;
    steady = mean(response($-window_size : $));
endfunction

Overshoot0 = max(y) - find_steady_idea0(y);
Overshoot1 = max(y) - find_steady_idea1(y);

// Real parametrization from overshoot
Csi_approx0 = sqrt(log(Overshoot0)^2 / (%pi^2 + log(Overshoot0)^2))
Csi_approx1 = sqrt(log(Overshoot1)^2 / (%pi^2 + log(Overshoot1)^2))

// why is it different?

// professor's code from here:

// Static gain
Y_ss = y($)
Est.K = Y_ss / A;
Est.Kerr = K - Est.K

// Damping factor
Overshoot = abs(max(y) - Y_ss) / abs(Y_ss);
Est.Csi = sqrt(log(Overshoot)^2 / (%pi^2 + log(Overshoot)^2));
Est.CsiErr = Csi - Est.Csi;

Est

