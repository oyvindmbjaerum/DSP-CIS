function [decoded_qam_symbols, channel_frequency_response, h_timedomain] = ofdm_demod(received_stream, frame_length, L, h, mask, trainblock)
    %Demodulate the OFDM signal
    fft_size = pow2(ceil(log2(frame_length)));

    received_stream = reshape(received_stream, fft_size + L, []);
    clipped_stream = received_stream(1:end - L,:); %remove cyclic prefix
    
    fft_packet = fft(clipped_stream, fft_size, 1);
    
    
    %Calculate the frequency response of the channel
    padded_trainblock = [0, trainblock.', 0, conj(trainblock).'].';
    train_mat = repmat(padded_trainblock, 1, size(fft_packet,2));

    h_est = zeros(length(padded_trainblock), 1);

    for i = 2 : length(padded_trainblock)/2
        h_est(i) = train_mat(i, :).' \ fft_packet(i, :).';         
    end


    h_est(fft_size/2 + 2 : end) = conj(flip(h_est(2:fft_size/2)));
    

    h_fft = fft(h, fft_size, 2).';
    h_error = abs(h_est - h_fft);

    h_timedomain = ifft(conj(h), fft_size , "symmetric");
    
    %Compensating for channel 
    channel_frequency_response = 1./(h_est);
    
    
    fft_packet_comped = fft_packet .*  channel_frequency_response;
    
    %Getting the data from the packet out
    decoded_qam_symbols = fft_packet_comped(2:frame_length/2, :);
end