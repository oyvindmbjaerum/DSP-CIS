function[serialised_packet] = ofdm_mod(qam_stream, frame_length, L, mask)
    mask = mask(2:length(mask)/2); %Take first half of mask so we dont zero out conjugates of any the carrier, or the first zeroed carrier
    on_carriers = find(mask(1:end) == 1);

    number_of_frames = ceil(length(qam_stream)/(length(on_carriers)));
    
    %Reshape the qam_stream so you can easily insert into packet matrix
    padded_qam_stream = zeros(number_of_frames*length(on_carriers), 1);
    padded_qam_stream(1:length(qam_stream)) = qam_stream;
    padded_qam_stream = reshape(padded_qam_stream, length(on_carriers), number_of_frames);

    packet = zeros(frame_length*number_of_frames, 1);


    for i = 1: number_of_frames
        on_indices = (i-1)*frame_length + on_carriers;
        packet(on_indices) = padded_qam_stream( :,i);
    end

    %packet(1:length(qam_stream)) = qam_stream;

    packet = reshape(packet, frame_length, number_of_frames); %Does not fit all package sizes
    
    full_size_packet = zeros(frame_length*2 + 2, number_of_frames);
    

    for k = 1:number_of_frames
        frame_firsthalf=  packet(:,k);
        frame_secondhalf = conj(frame_firsthalf);
        full_size_packet(:,k) = [0, frame_firsthalf.',  0, frame_secondhalf.'];
     
    end

    ifft_size = pow2(ceil(log2(size(full_size_packet, 1))));
    ifft_packet = ifft(full_size_packet, ifft_size, 1); 

    %Adding a cyclic prefix
    padded_packet = zeros(size(ifft_packet, 1) + L, size(ifft_packet, 2));
    padded_packet(1:size(ifft_packet, 1),:) = ifft_packet;
    padded_packet(size(ifft_packet, 1) + 1:end,:) = ifft_packet(1:L,:);
    
    serialised_packet = reshape(padded_packet, [], 1);
end