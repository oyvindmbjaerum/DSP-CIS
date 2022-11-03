clf;

M = 16;
k = log2(M);

random_sequence = randi([0 1],1000*k,1);

symbol_sequence = qam_mod(random_sequence, M);
scatterplot(symbol_sequence)

noisy_sequence = awgn(symbol_sequence, 10);

figure(1)
scatterplot(noisy_sequence)

output_sequence = qam_demod(symbol_sequence, M);

figure(2)
scatterplot(output_sequence)

[number, ratio] = ber(random_sequence,output_sequence);


