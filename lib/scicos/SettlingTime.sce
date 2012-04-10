function [settlingtime] = SettlingTime (behavior, winsize, epsilon)

    settlingtime = -1;
    [x, ipeak] = max(behavior(2,:));

    win = behavior(2, ipeak : ipeak + winsize);
    for i = [ipeak + winsize : size(behavior, 2) - winsize]
        win(pmodulo(i, winsize) + 1) = behavior(2, i);
        if (stdev(win) <= epsilon)
            x = i;
            break;
        end
    end

    settlingtime = behavior(1, x);

endfunction
