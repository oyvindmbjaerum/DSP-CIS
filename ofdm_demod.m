function [decoded_qam_symbols, channel_frequency_response, h] = ofdm_demod(received_stream, frame_length, L, h, mask, trainblock)
    %Demodulate the OFDM signal
    fft_size = pow2(ceil(log2(frame_length)));

    received_stream = reshape(received_stream, fft_size + L, []);
    clipped_stream = received_stream(L:end,:); %remove cyclic prefix
    
    fft_packet = fft(clipped_stream, fft_size, 1);
    
    
    %Calculate the frequency response of the channel
    padded_trainblock = [0, trainblock.', 0, conj(trainblock).'].';
    train_mat = repmat(padded_trainblock, 1, size(fft_packet,2));

    h = zeros(length(padded_trainblock), 1);
    h_lsqr = zeros(length(trainblock), 1);
    for i = 1: length(padded_trainblock)
        h(i) = train_mat(i, :).' \ fft_packet(i, :).';         
        h_lsqr(i) = lsqr(train_mat(i, :).', fft_packet(i, :).');
        %h_lsqr(i) = mean(reconstructed_packet(i, :));
    end
    
    H = train_mat.' \ fft_packet.';
    h_other = H((find(H(:, 1)==max(H(:, 1)))), :).';

    
    
    %Compensating for channel 
    channel_frequency_response = 1./(fft((h), fft_size));
    
    
    fft_packet_comped = fft_packet .*  channel_frequency_response;
    
    %Getting the data from the packet out
    decoded_qam_symbols = fft_packet_comped(2:frame_length/2, :);
end