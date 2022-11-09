function[padded_packet] =ofdm_mod(bit_stream, M, frame_length, L)

    packet = reshape(bit_stream, frame_length*log2(M), length(bit_stream)/(frame_length*log2(M)));
    
    full_size_packet = zeros(frame_length*2, length(bit_stream)/(frame_length*log2(M)));
    

    for k = 1:size(packet,2)
        frame_firsthalf= qam_mod( packet(:,k), M);
        frame_secondhalf = conj(frame_firsthalf);
        full_size_packet(:,k) = [frame_firsthalf.', frame_secondhalf.'];
     
    end
    full_size_packet(1,:) = 0;
    full_size_packet(frame_length,:) = 0;

    ifft_packet = ifft(full_size_packet, frame_length*2, 1);
    

    %Adding a cyclic prefix
    padded_packet = zeros(size(ifft_packet, 1) + L, size(ifft_packet, 2));
    padded_packet(1:size(ifft_packet, 1),:) = ifft_packet;
    padded_packet(size(ifft_packet, 1) + 1:end,:) = ifft_packet(1:L,:);

end