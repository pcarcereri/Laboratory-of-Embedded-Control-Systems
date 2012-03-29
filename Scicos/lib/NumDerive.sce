// Numerical derivation, i.e. compute the

function [xso, yso] = NumDerive (ts, ys)
    xso = ts(2:$);
    yso = (ys(2:$) - ys(1:$-1)) ./ (ts(2:$) - ts(1:$-1));
endfunction
