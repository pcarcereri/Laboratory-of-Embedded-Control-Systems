function [overshoot] = Overshoot(response, steady)
    peak = max(response(2,:)); //find the max in the response row
    overshoot = peak - steady;
endfunction
