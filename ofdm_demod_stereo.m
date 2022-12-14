function [decoded_qam_stream] = ofdm_demod_stereo(received_stream, fft_size, L, mask, trainblock, n_training_frames, n_data_frames, h_combined)
    
    on_carriers = find(mask == 1);

    %Demodulate the OFDM signal
    received_stream = reshape(received_stream, fft_size + L, []);
    clipped_stream = received_stream(L + 1:end,:); %remove cyclic prefix
    
    fft_packet = fft(clipped_stream, fft_size, 1);
    


    decoded_qam_stream =  (fft_packet ./  (h_combined));

    decoded_qam_stream = decoded_qam_stream(on_carriers + 1, :);
end