function [error_rate] = qam_experiment(M, snr)
    k = log2(M);
    random_sequence = randi([0 1],1000*k,1);
    symbol_sequence = qam_mod(random_sequence, M);
    noisy_sequence = awgn(symbol_sequence, snr, 'measured');
    output_sequence = qam_demod(noisy_sequence, M);
    [~, error_rate] = ber(random_sequence, output_sequence);
end


