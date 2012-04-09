function ret = SystemFrequency (behavior, risetime, xi)

    vals = behavior(2,:);

    [M1, iM1] = max(vals);      // overshoot peak
    tM1 = behavior(1, iM1);

    i = iM1;
    while (behavior(1, i) < tM1 + 1.5 * risetime)
        i = i + 1;
    end
    [m1, im1] = min(vals(iM1:i));
    im1 = im1 + iM1;
    tm1 = behavior(1, im1);
    while (behavior(1, i) < tm1 + 1.5 * risetime)
        i = i + 1;
    end
    [M2, iM2] = max(vals(im1:i));
    iM2 = iM2 + im1;
    tM2 = behavior(1, iM2);

    T = tM2 - tM1;
    ret = [(2 * %pi) / (T * sqrt(1 - xi^2)), tM1, tM2];

endfunction
