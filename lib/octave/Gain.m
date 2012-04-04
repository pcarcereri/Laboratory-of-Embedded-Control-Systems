function [EstK,EstCsi] = Gain (response, overshoot, amplitude)

Y_ss = response(size(response));
EstK = Y_ss / amplitude;
#Est.Kerr = K - Est.K

# Damping factor
Overshoot = abs(max(response) - Y_ss) / abs(Y_ss);
EstCsi = sqrt(log(overshoot)^2 / (pi^2 + log(overshoot)^2));
#Est.CsiErr = Csi - Est.Csi;

endfunction

