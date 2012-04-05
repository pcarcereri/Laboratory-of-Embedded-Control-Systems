function [outfun] = WinAvgFilter (infun, winsize)

    outfun = infun(:, 1 : $ - winsize);
    buf = [];
    for i = 1 : size(outfun, 2)
        buf(pmodulo(i, winsize) + 1) = infun(2, i);
        outfun(2, i) = mean(buf);
    end

endfunction
