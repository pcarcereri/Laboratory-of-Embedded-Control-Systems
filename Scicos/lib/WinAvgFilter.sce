// Filter out data to remove measure noise.

function out = WinAvgFilter (in, winsize)

    N = size(in, 2);
    for i = [1 : N - winsize + 1]
        weight = 1;
        acc = 0;
        wacc = 0;

        for v = in(i : i + winsize - 1)
            acc = acc + weight * v;
            wacc = wacc + weight;
            weight = weight / 2;
        end

        if (wacc == 0)
            out(1, i) = 0;
        else
            out(1, i) = acc / wacc;
        end
    end

endfunction

// Filtering of data
// Writing such a trivial function has been a HELL. What the heck were
// they thinking when they wrote this crappy language?
//
// Hints: never use operators like += and friends. And when you use the
// 'disp' function (for displaying variable content) be aware that prints
// data in *REVERSE ORDER* (Yeah, seriously!).


