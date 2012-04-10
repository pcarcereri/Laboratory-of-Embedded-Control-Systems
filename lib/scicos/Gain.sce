function g = Gain (sin_behavior, ratios)

    vals = abs(sin_behavior(2,:));
    g = max(vals);

    for r = ratios
        m = mean( vals( vals >= max(vals) * r ) );
        g = mean([m, g]);
    end

endfunction
