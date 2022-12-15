fs = 16000;
fft_size = 256; %same as frame length

n_symbols = fft_size/2 -1;
M = 16;
L = 32;

n_training_frames = 0;
n_data_frames = 1;


k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

mask = ones(fft_size/2 - 1, 1);
trainblock = qam_mod(training_bits, M); %training block of QAM symbols



[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

qamStream = qam_mod(bitStream, M);


left_speaker_response = randn(fft_size,1,"like",1i) * 0.1;
right_speaker_response = randn(fft_size,1,"like",1i) * 0.1;

%left_speaker_response = zeros(fft_size, 1);
%left_speaker_response(1) = 1;
%right_speaker_response = zeros(fft_size, 1);

[a, b, h_comb] = fixed_transmitter_side_beamformer(left_speaker_response, right_speaker_response);

[left_ofdm_stream, right_ofdm_stream] = ofdm_mod_stereo(qamStream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames, a, b);



received_signal = conv(left_speaker_response, left_ofdm_stream) + conv(right_speaker_response, right_ofdm_stream);



rx_qam_stream = ofdm_demod_stereo(received_signal(1: end - (fft_size - 1)), fft_size, L, mask, trainblock, n_training_frames, n_data_frames, h_comb);

rx_bit_stream = qam_demod(rx_qam_stream, M);


[berTransmission, ratio, error_locations] = ber(bitStream, rx_bit_stream(1: length(bitStream)));


figure(6);
subplot(3, 1, 1);
stem(fft(left_speaker_response));
subplot(3, 1, 2);
stem(fft(right_speaker_response));

subplot(3, 1, 3);
stem(h_comb);

