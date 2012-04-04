function [outfun] = WinAvgFilter (infun, winsize)

    N = size(infun, 2) - winsize + 1;
    outfun = zeros(2, N);

    for i = [1 : N]
        weight = 1;
        acc = 0;
        wacc = 0;

        for v = infun(2, i : i + winsize - 1)
            acc = acc + weight * v;
            wacc = wacc + weight;
            weight = weight / 2;
        end

        if (wacc == 0)
            outfun(2, i) = 0;
        else
            outfun(2, i) = acc / wacc;
        end
        outfun(1, i) = infun(1, i);

    end

endfunction
