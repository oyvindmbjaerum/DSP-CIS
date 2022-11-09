clf;

M = 8;
k = log2(M);
SNRdB = 16;


random_sequence = randi([0 1],1000*k,1);

symbol_sequence = qam_mod(random_sequence, M);


noisy_sequence = awgn(symbol_sequence, SNRdB);



output_sequence = qam_demod(noisy_sequence, M);


[number, ratio] = ber(random_sequence, output_sequence)


