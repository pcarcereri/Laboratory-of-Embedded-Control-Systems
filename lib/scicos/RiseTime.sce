function rt = RiseTime (behavior, steady, max_rate, min_rate)

    ss_ratios = behavior(2,:) / steady;
    begin_idx = find(ss_ratios > min_rate, 1);
    end_idx = find(ss_ratios > max_rate, 1);

    rt = behavior(1, end_idx) - behavior(1, begin_idx);

endfunction
