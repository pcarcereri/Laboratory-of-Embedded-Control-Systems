function [outfun] = ButterFilter (infun, cut_freq)

    outfun = [];

    [poles, gain] = zpbutt(2, cut_freq);
    H = gain / real(poly(poles, 's'));
    outfun(1,:) = infun(1,:);
    outfun(2,:) = csim(infun(2,:), infun(1,:) / 1000, H);

endfunction
