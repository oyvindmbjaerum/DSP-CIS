function [h_est_left, h_est_right] = ofdm_channelest(trainblock, received_stream, L_t, fft_size, L)
    padded_trainblock = [0, trainblock.', 0, flip(conj(trainblock)).'].';
    train_mat = repmat(padded_trainblock, 1, L_t);


    clipped_stream = received_stream(1: 2*L_t*(fft_size + L));
    clipped_stream = reshape(clipped_stream, fft_size + L, []);    
    clipped_stream = clipped_stream(L + 1 : end, :);

    fft_packet = fft(clipped_stream, fft_size, 1);

    left_speaker_stream = fft_packet(:, 1 : L_t);
    right_speaker_stream = fft_packet(:, end - (L_t - 1) : end);

    h_est_left = zeros(fft_size, 1);

    for i = 2 : length(padded_trainblock)/2 %Only looping through carriers holding data
        h_est_left(i) = train_mat(i, :).' \ left_speaker_stream(i, : ).';         
    end

    h_est_right = zeros(fft_size, 1);

    for i = 2 : length(padded_trainblock)/2 %Only looping through carriers holding data
        h_est_right(i) = train_mat(i, :).' \ right_speaker_stream(i, : ).';         
    end

    h_est_left(fft_size/2 + 2 : end) = flip(conj(h_est_left(2:fft_size/2)));
    h_est_right(fft_size/2 + 2 : end) = flip(conj(h_est_right(2:fft_size/2)));
end
