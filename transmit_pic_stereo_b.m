fs = 16000;
fft_size = 256; %same as frame length
impulse_response_length = 5000;

n_symbols = fft_size/2 -1;
M = 4;
L = 32;

k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

mask = ones(fft_size/2 - 1, 1);
trainblock = qam_mod(training_bits, M); 

[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

qamStream = qam_mod(bitStream, M);

%USING ONLY LEFT SPEAKER
left_scalars = ones(fft_size, 1);
right_scalars = zeros(fft_size, 1);

n_training_frames = 2;
n_data_frames = 5;


[left_ofdm_stream, right_ofdm_stream] = ofdm_mod_stereo(qamStream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames, left_scalars, right_scalars);

[simin, nbsecs, fs, pulse] = initparams_stereo(left_ofdm_stream, right_ofdm_stream, fs, impulse_response_length);


sim('recplay');
out=simout.signals.values;


[Rx, estimated_lag] = alignIO(out, pulse, impulse_response_length);

rx_qam_stream = ofdm_demod_stereo(Rx, fft_size, L, mask, trainblock, n_training_frames, n_data_frames);

rx_bit_stream = qam_demod(rx_qam_stream, M);

[berleft, ratio_leftonly, error_locations_left] = ber(bitStream, rx_bit_stream(1: length(bitStream)));

%%
%%USING ONLY RIGHT SPEAKER

left_scalars = zeros(fft_size, 1);
right_scalars = ones(fft_size, 1);


[left_ofdm_stream, right_ofdm_stream] = ofdm_mod_stereo(qamStream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames, left_scalars, right_scalars);

[simin, nbsecs, fs, pulse] = initparams_stereo(left_ofdm_stream, right_ofdm_stream, fs, impulse_response_length);


sim('recplay');
out=simout.signals.values;


[Rx, estimated_lag] = alignIO(out, pulse, impulse_response_length);

rx_qam_stream = ofdm_demod_stereo(Rx, fft_size, L, mask, trainblock, n_training_frames, n_data_frames);

rx_bit_stream = qam_demod(rx_qam_stream, M);

[berright, ratio_rightonly, error_locations_right] = ber(bitStream, rx_bit_stream(1: length(bitStream)));

%USING OPTIMAL LEFT AND RIGHT SPEAKERS
%%
n_training_frames = 0;
n_data_frames = 10; %The training frames are the data frames when there should be no intermittent training frames

train_mat = repmat(trainblock, 1, n_data_frames);

full_qam_symbols_left = zeros(n_data_frames*2*(fft_size/2 -1), 1);
full_qam_symbols_left(1:n_data_frames*(fft_size/2 -1)) = reshape(train_mat, [], 1);

full_qam_symbols_right = zeros(n_data_frames*2*(fft_size/2 -1), 1);
full_qam_symbols_right(n_data_frames*(fft_size/2 -1) + 1 : end) = reshape(train_mat, [], 1);

%Do not use any special channel compensation when generating frames meant
%for estimating the freq response for the two speakers
a = ones(fft_size, 1);
b = ones(fft_size, 1);


[left_ofdm_stream_real, right_ofdm_stream] = ofdm_mod_stereo(full_qam_symbols_left, trainblock, fft_size, L, mask, n_training_frames, n_data_frames, a, b);
[left_ofdm_stream, right_ofdm_stream_real] = ofdm_mod_stereo(full_qam_symbols_right, trainblock, fft_size, L, mask, n_training_frames, n_data_frames, a, b);


[simin, nbsecs, fs, pulse] = initparams_stereo(left_ofdm_stream_real, right_ofdm_stream_real, fs, impulse_response_length);


sim('recplay');
out=simout.signals.values;


[Rx_training, estimated_lag] = alignIO(out, pulse, impulse_response_length);

[left_h, right_h] = ofdm_channelest(trainblock, Rx_training, n_data_frames, fft_size, L);


diff = abs(left_h - right_h);


[a, b, h_comb] = fixed_transmitter_side_beamformer(ifft(left_h), ifft(right_h), fft_size);


n_training_frames = 2;
n_data_frames = 5;


[left_ofdm_stream, right_ofdm_stream] = ofdm_mod_stereo(qamStream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames, a, b);


[simin, nbsecs, fs, pulse] = initparams_stereo(left_ofdm_stream, right_ofdm_stream, fs, impulse_response_length);


sim('recplay');
out=simout.signals.values;

[Rx, estimated_lag] = alignIO(out, pulse, impulse_response_length);

rx_qam_stream = ofdm_demod_stereo(Rx, fft_size, L, mask, trainblock, n_training_frames, n_data_frames);

rx_bit_stream = qam_demod(rx_qam_stream, M);

[ber_ideal, ratio_ideal, error_locations_ideal] = ber(bitStream, rx_bit_stream(1: length(bitStream)));

