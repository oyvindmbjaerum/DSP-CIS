

fs = 16000;
fft_size = 256; %same as frame length
n_training_frames = 2;
n_data_frames = 5;
n_symbols = fft_size/2 -1;
M = 4;
L = 16;
impulse_response_length = 500;
k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

mask = ones(fft_size/2 -1, 1);

trainblock = qam_mod(training_bits, M); %training block of QAM symbols


[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream, M);


[Tx, ifft_packet] = ofdm_mod(qamStream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames);



[simin, nbsecs, fs, pulse] = initparams(Tx,fs, impulse_response_length);

%Timing the transmission time
tic;
sim('recplay');
toc = transmission_time;


Rx = simout.signals.values;
[Rx_lag_comped, estimated_lag] = alignIO(Rx, pulse, impulse_response_length);


[rx_qam_stream,  channel_est] = ofdm_demod(Rx_lag_comped, fft_size, L, mask, trainblock, n_training_frames, n_data_frames); % (1:end - (length(channel_constants) -1),:)
rx_bit_stream = qam_demod(rx_qam_stream, M);


[berTransmission, ratio, error_locations] = ber(bitStream, rx_bit_stream(1: length(bitStream)));

