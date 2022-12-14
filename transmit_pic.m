%%
%Code for estimating channel and calculating mask for ON OFF bit loading
fs = 16000;
fft_size = 256; %same as frame length
n_training_frames = 100;
n_data_frames = 0;
n_symbols = fft_size/2 -1;
M = 4;
L = 16;
impulse_response_length = 5000;
k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);






mask = ones(fft_size/2 - 1, 1);

trainblock = qam_mod(training_bits, M); %training block of QAM symbols


[Tx] = ofdm_mod(trainblock, trainblock, fft_size, L, mask, n_training_frames, n_data_frames);




[simin, nbsecs, fs, pulse] = initparams(Tx,fs, impulse_response_length);

tic
sim('recplay');
dummy_transmission_time = toc;

out=simout.signals.values;


[Rx, estimated_lag] = alignIO(out, pulse, impulse_response_length);
[rx_qam_stream,  channel_est] = ofdm_demod(Rx, fft_size, L, mask, trainblock, n_training_frames, n_data_frames); % (1:end - (length(channel_constants) -1),:)


[mask] = on_off_mask(channel_est, fft_size, BWusage);
%%
%Code for transmitting image
fs = 16000;
fft_size = 256; %same as frame length
n_training_frames = 2;
n_data_frames = 5;
n_symbols = fft_size/2 -1;
M = 4;
L = 16;
impulse_response_length = 5000;
k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

trainblock = qam_mod(training_bits, M); %training block of QAM symbols


[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream, M);


[Tx] = ofdm_mod(qamStream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames);



[simin, nbsecs, fs, pulse] = initparams(Tx,fs, impulse_response_length);

%Timing the transmission time
tic;
sim('recplay');
%[Rx] = simulate_channel(Tx, n_training_frames, n_data_frames, fft_size, L);


transmission_time = toc;


Rx = simout.signals.values;

%%
[Rx_lag_comped, estimated_lag] = alignIO(Rx, pulse, impulse_response_length);


[rx_qam_stream,  channel_est] = ofdm_demod(Rx_lag_comped, fft_size, L, mask, trainblock, n_training_frames, n_data_frames); % (1:end - (length(channel_constants) -1),:)
rx_bit_stream = qam_demod(rx_qam_stream, M);


[berTransmission, ratio, error_locations] = ber(bitStream, rx_bit_stream(1: length(bitStream)));
%%
figure(2);
plot(Rx);
figure(3);
plot(Rx_lag_comped);
