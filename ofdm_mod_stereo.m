function [left_ofdm_stream, right_ofdm_stream] = ofdm_mod_stereo(qam_stream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames, left_scalars, right_scalars)
     n_frames = ceil(length(qam_stream)/(fft_size/2 -1));
     qam_stream(n_frames*(fft_size/2 -1)) = 0;

    packet = reshape(qam_stream, fft_size/2 - 1, []);
    
    full_size_packet = zeros(fft_size, n_frames);

    for k = 1: n_frames
        frame_firsthalf=  packet(:,k);
        frame_secondhalf = conj(frame_firsthalf);
        full_size_packet(:,k) = [0, frame_firsthalf.',  0, frame_secondhalf.'];
     
    end


    left_data_packet =  bsxfun(@times, full_size_packet, left_scalars);
    right_data_packet =  bsxfun(@times, full_size_packet, right_scalars);

    left_ifft_packet =  ifft(left_data_packet, fft_size, 1); 
    right_ifft_packet =  ifft(right_data_packet, fft_size, 1); 
    

    %Adding a cyclic prefix
    left_ofdm_mat_padded = zeros(fft_size + L, n_frames);
    left_ofdm_mat_padded(L+1:end,:) = left_ifft_packet;
    left_ofdm_mat_padded(1:L,:) = left_ifft_packet(end - L + 1:end,:);


    right_ofdm_mat_padded = zeros(fft_size + L, n_frames);
    right_ofdm_mat_padded(L+1:end,:) = right_ifft_packet;
    right_ofdm_mat_padded(1:L,:) = right_ifft_packet(end - L + 1:end,:);


    left_ofdm_stream = reshape(left_ofdm_mat_padded, [], 1);
    right_ofdm_stream = reshape(right_ofdm_mat_padded, [], 1);
end