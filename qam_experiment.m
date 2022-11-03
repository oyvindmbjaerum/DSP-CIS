order = 6;
N = 2^(order)-1;

length = 1000;

random_sequence = prbs(order, length)

constellation = qam_mod(random_sequence, 2^order);


scatterplot(constellation)

