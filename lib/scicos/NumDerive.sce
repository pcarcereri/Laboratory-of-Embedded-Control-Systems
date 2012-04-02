function outfun = NumDerive (infun)
    outfun(1,:) = infun(1, 2:$);
    outfun(2,:) = (infun(2, 2:$) - infun(2, 1:$-1)) ./ (infun(1, 2:$) - infun(1, 1:$-1));
endfunction
