function outfun = NumDerive (infun)
    N = size(infun, 2);
    outfun(1,:) = infun(1, 2:N);
    outfun(2,:) = (infun(2, 2:N) - infun(2, 1:N-1)) ./ (infun(1, 2:N) - infun(1, 1:N-1));
endfunction
