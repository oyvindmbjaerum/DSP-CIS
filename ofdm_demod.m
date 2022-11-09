function [decoded_packet] = ofdm_demod(received_stream, M, frame_length, L)
    
    clipped_stream = received_stream(1:end - L ,:); %remove cyclic prefix
    fft_packet = fft(clipped_stream, frame_length*2, 1 );
    
    decoded_packet = zeros(frame_length*log2(M), size(clipped_stream, 2));
    for k = 1:size(fft_packet,2)
        decoded_symbols= qam_demod(fft_packet(:,k), M);
        decoded_packet(:,k) = decoded_symbols(1:length(decoded_symbols)/2); 
    end



end