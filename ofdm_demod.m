function [reconstructed_packet] = ofdm_demod(received_stream, frame_length, L, h)
    
    fft_size = pow2(ceil(log2(frame_length)))*2;
    freq_response = fft(h, fft_size, 1);
    freq_response = 1./freq_response;

    received_stream = reshape(received_stream, pow2(ceil(log2(frame_length)))*2 + L, []);
    clipped_stream = received_stream(1:end - L,:); %remove cyclic prefix
    
    fft_packet = fft(clipped_stream, fft_size, 1);
    
    
    %fft_packet = fft_packet .*  freq_response;

    reconstructed_packet = fft_packet(2:size(fft_packet, 1)/2,:);

    reconstructed_packet = reconstructed_packet(1:frame_length, :);
end