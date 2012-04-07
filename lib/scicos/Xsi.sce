function [csi] = Xsi (overshoot)
    csi = sqrt(log(overshoot)^2 / (%pi^2 + log(overshoot)^2));
endfunction
