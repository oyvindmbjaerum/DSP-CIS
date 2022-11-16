function [decoded_qam_symbols] = ofdm_demod(received_stream, frame_length, L, h, mask)
    
if floor(log2(frame_length))==log2(frame_length)
        fft_size = pow2(log2(frame_length));
    else
        fft_size = pow2(ceil(log2(frame_length)));
    end

    received_stream = reshape(received_stream, fft_size + L, []);
    clipped_stream = received_stream(1:end - L,:); %remove cyclic prefix
    
    fft_packet = fft(clipped_stream, fft_size, 1);
    
    %Compensating for channel 
    channel_comp = (1./fft(h, fft_size));
    
    %fft_packet = fft_packet .*  channel_comp;



    reconstructed_packet = fft_packet(2:frame_length/2, :);
    

    %Get only the used carriers out
    mask = mask(2:length(mask)/2); %Take first half of mask, because we do not care about the conjugates, and drop the first one because it is always zeroed
    carriers_used = find(mask == 1);


    decoded_qam_symbols = zeros(length(carriers_used), size(reconstructed_packet, 2));

    for i = 1 : size(reconstructed_packet, 2)
    decoded_qam_symbols(:,i) = reconstructed_packet(carriers_used,i);
    end    

    
end