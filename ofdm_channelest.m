fft_size = 512; %same as frame length
n_identical_frames = 100;
n_symbols = fft_size/2 -1;
M = 16;
L = 64;



k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

mask = ones(fft_size, 1);


channel = load("IRest.mat");

trainblock = qam_mod(training_bits, M); %training block of QAM symbols

Tx = ofdm_mod(trainblock, fft_size, L, mask);


Tx_mat = repmat(Tx, 1, n_identical_frames);

Tx = reshape(Tx_mat, [], 1);



Rx = conv(channel.h, Tx);


rx_qam_stream = ofdm_demod(Rx(1:end - (length(channel.h) -1),:), fft_size, L, channel.h, mask, trainblock);


rx_bit_stream = qam_demod(rx_qam_stream, M);

[berTransmission, ratio, error_locations] = ber(repmat(random_bits, 1, n_identical_frames), rx_bit_stram);


