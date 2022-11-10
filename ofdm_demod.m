function [reconstructed_packet] = ofdm_demod(received_stream, frame_length, L, h)
    freq_response = fft(h, pow2(ceil(log2(frame_length))), 1);
    freq_response = 1./freq_response;

    received_stream = reshape(received_stream, pow2(ceil(log2(frame_length))) + L, []);
    clipped_stream = received_stream(1:end - L,:); %remove cyclic prefix
    fft_packet = fft(clipped_stream, pow2(ceil(log2(frame_length))), 1);
    
    fft_packet = fft_packet .*  freq_response;


    reconstructed_packet = fft_packet(2:size(fft_packet, 1)/2 +2 ,:);
end