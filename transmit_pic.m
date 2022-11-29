

fs = 16000;
fft_size = 256; %same as frame length
n_training_frames = 2;
n_data_frames = 5;
n_symbols = fft_size/2 -1;
M = 16;
L = 16;

k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

mask = ones(fft_size, 1);

trainblock = qam_mod(training_bits, M); %training block of QAM symbols


[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream, M);


[Tx, ifft_packet] = ofdm_mod(qamStream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames);

[Rx] = simulate_channel(Tx, n_training_frames, n_data_frames, fft_size, L);

%[Rx, estimated_lag] = alignIO(out, pulse, length(channel_constants));
[rx_qam_stream,  channel_est] = ofdm_demod(Rx, fft_size, L, mask, trainblock, n_training_frames, n_data_frames); % (1:end - (length(channel_constants) -1),:)
rx_bit_stream = qam_demod(rx_qam_stream, M);


[berTransmission, ratio, error_locations] = ber(bitStream, rx_bit_stream(1: length(bitStream)));

imageRx = bitstreamtoimage(rx_bit_stream, imageSize, bitsPerPixel);


% Plot images
figure(1);
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;

