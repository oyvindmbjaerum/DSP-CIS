function[serialised_packet] =ofdm_mod(qam_stream, frame_length, L)

    packet = reshape(qam_stream, frame_length, length(qam_stream)/(frame_length));
    
    full_size_packet = zeros(frame_length*2 + 2, length(qam_stream)/(frame_length));
    

    for k = 1:size(packet,2)
        frame_firsthalf=  packet(:,k);
        frame_secondhalf = conj(frame_firsthalf);
        full_size_packet(:,k) = [0, frame_firsthalf.',  0, frame_secondhalf.'];
     
    end
    ifft_packet = ifft(full_size_packet, pow2(ceil(log2(frame_length))), 1); 

    %Adding a cyclic prefix
    padded_packet = zeros(size(ifft_packet, 1) + L, size(ifft_packet, 2));
    padded_packet(1:size(ifft_packet, 1),:) = ifft_packet;
    padded_packet(size(ifft_packet, 1) + 1:end,:) = ifft_packet(1:L,:);
    serialised_packet = reshape(padded_packet, [], 1);
end