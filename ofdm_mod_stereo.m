function [left_ofdm_stream, right_ofdm_stream] = ofdm_mod_stereo(qam_stream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames, left_scalars, right_scalars)
    
    [ofdm_stream, full_size_packet] = ofdm_mod(qam_stream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames);

    left_data_packet =  bsxfun(@times, full_size_packet, left_scalars);
    right_data_packet =  bsxfun(@times, full_size_packet, right_scalars);

    left_ifft_packet =  ifft(left_data_packet, fft_size, 1); 
    right_ifft_packet =  ifft(right_data_packet, fft_size, 1); 
    

    %Adding a cyclic prefix
    left_ofdm_mat_padded = zeros(fft_size + L, size(full_size_packet, 2));
    left_ofdm_mat_padded(L+1:end,:) = left_ifft_packet;
    left_ofdm_mat_padded(1:L,:) = left_ifft_packet(end - L + 1:end,:);


    right_ofdm_mat_padded = zeros(fft_size + L, size(full_size_packet, 2));
    right_ofdm_mat_padded(L+1:end,:) = right_ifft_packet;
    right_ofdm_mat_padded(1:L,:) = right_ifft_packet(end - L + 1:end,:);


    left_ofdm_stream = reshape(left_ofdm_mat_padded, [], 1);
    right_ofdm_stream = reshape(right_ofdm_mat_padded, [], 1);
end