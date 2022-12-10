fs = 16000;
fft_size = 256; %same as frame length
n_identical_frames = 100;
n_symbols = fft_size/2 -1;
M = 16;
L = 32;

k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

mask = ones(fft_size, 1);


channel = load("IRmeasured.mat");
channel_constants = channel.h;

trainblock = qam_mod(training_bits, M); %training block of QAM symbols

[Tx, ifft_packet] = ofdm_mod(trainblock, fft_size, L, mask);
Tx_mat = repmat(Tx, 1, n_identical_frames);
Tx = reshape(Tx_mat, [], 1);
ifft_packet = repmat(ifft_packet, 1, n_identical_frames);


[simin, nbsecs, fs, pulse] = initparams(Tx,fs, length(channel_constants));
sim('recplay');
out=simout.signals.values;


[Rx, estimated_lag] = alignIO(out, pulse, length(channel_constants));
[rx_qam_stream, channel_frequency_response, h_est2] = ofdm_demod(Rx, fft_size, L, channel_constants, mask, trainblock, n_identical_frames); % (1:end - (length(channel_constants) -1),:)
rx_bit_stream = qam_demod(rx_qam_stream, M);



training_mat = repmat(training_bits, 1, n_identical_frames);
training_bits_n = reshape(training_mat, [], 1);

[berTransmission, ratio, error_locations] = ber(training_bits_n, rx_bit_stream);
%%
figure(7);
stem(channel_constants);
title("Time response of channel");
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


figure(8);
stem(h_est2);
title("Estimated Time response of channel");
xlabel('Samples');

figure(5);
freqz(h_est2, 1);
