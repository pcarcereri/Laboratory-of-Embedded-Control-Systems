function flt = WinAvgFilter (behavior, k = 500)

    flt = behavior(:, 1 : end - k);
    buf = zeros(1, k);
    for i = 1 : length(flt)
        buf(mod(i, k) + 1) = behavior(2, i);
        flt(2, i) = mean(buf);
    end

endfunction

