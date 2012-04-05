//settling time method, il takes the timestamps and value rows,the ss and a given epsilon

function [settlingtime] = SettlingTime (behavior, steadystate, epsilon)

    // TODO Quick and dirthy to be optimized.
    response = behavior(2,:)';
    timestamps = behavior(1,:)';

    //trovo l'indice massimo ovvero l'ultimo istante in cui il valore è sopra la soglia
    p1 = max( find(response > ( steadystate * (1 + epsilon)) ));
    //trovo l'indice massimo ovvero l'ultimo istante in cui il valore è sotto la soglia
    p2 = max( find(response < (steadystate * (1 - epsilon)) ));
    //settling time given by the value of the time vector between the indexes
    settlingtime = timestamps(max(p1, p2));

endfunction
