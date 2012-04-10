function g = Gain (sin_behavior, ratios)

    vals = abs(sin_behavior(2,:));
    g = max(vals);

    M = g;
    for r = ratios
        m = mean( vals( vals >= M * r ) );
        g = mean([m, g]);
    end

endfunction
