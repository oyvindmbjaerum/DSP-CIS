fft_size = 512; %same as frame length
n_identical_frames = 100;
n_symbols = fft_size/2 -1;
M = 8;
L = 32;

k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

mask = ones(fft_size, 1);


channel = load("IRest.mat");
channel_constants = channel.h;

trainblock = qam_mod(training_bits, M); %training block of QAM symbols

Tx = ofdm_mod(trainblock, fft_size, L, mask);


Tx_mat = repmat(Tx, 1, n_identical_frames);

Tx = reshape(Tx_mat, [], 1);



%channel_constants = zeros(fft_size, 1);
%channel_constants(1) = 1;


Rx = conv(channel_constants, Tx);



[rx_qam_stream, channel_frequency_response, h_est] = ofdm_demod(Rx(1:end - (length(channel_constants) -1),:), fft_size, L, channel_constants, mask, trainblock); % (1:end - (length(channel_constants) -1),:)


rx_bit_stream = qam_demod(rx_qam_stream, M);

training_mat = repmat(training_bits, 1, n_identical_frames);
training_bits_n = reshape(training_mat, [], 1);

[berTransmission, ratio, error_locations] = ber(training_bits_n, rx_bit_stream);


figure(1);
subplot(2, 1, 1);

stem(channel_constants);
title("Time response of estimated impulse response");
xlabel('Samples');


% freq_response = fft(channel_constants);
% L = length(channel_constants);
% P2 = abs(freq_response/L);
% P2 = P2';
% P1 = P2(:,1:L/2+1);
% P1(:,2:end-1) = 2*P1(:,2:end-1); %Change to magnitude by squaring
% 
% P1db = mag2db(P1);
% f = fs*(0:(L/2))/L;
% plot(f, P1db)
% title("Frequency response of estimated impulse response");
% xlabel('Frequency (HZ)');
% ylabel('Frequency response magnitude(dB)');


figure(3);
stem(h_est);

figure(5);
freqz(h_est, 1);
