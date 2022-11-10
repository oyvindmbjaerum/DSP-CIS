% Exercise session 4: DMT-OFDM transmission scheme


function   [berTransmission, ratio, error_locations] = main(frame_length, M, L, snr, channel_constants)
    
    
    % Convert BMP image to bitstream
    [bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');
    full_frames_needed = ceil( length(bitStream)/ frame_length );
    full_bitstream = zeros(full_frames_needed * frame_length , 1);
    full_bitstream(1: length(bitStream)) = bitStream;

    % QAM modulation
    qamStream = qam_mod(full_bitstream, M);
    
    % OFDM modulation
    ofdmStream = ofdm_mod(qamStream, frame_length, L);
    
    % Channel
    %rxOfdmStream = awgn(ofdmStream, snr);
   
    rxOfdmStream =  conv(channel_constants, ofdmStream);
    
    % OFDM demodulation
    rxQamStream = ofdm_demod(rxOfdmStream(1:end - (length(channel_constants) -1),:), frame_length, L, channel_constants);
    
    % QAM demodulation
    rxBitStream = qam_demod(rxQamStream, M);
    
    rxBitStream = rxBitStream(1:end - (frame_length - rem(length(bitStream), frame_length)));

    % Compute BER
    [berTransmission, ratio, error_locations] = ber(bitStream,rxBitStream);
    
    
    % Construct image from bitstream
    imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);
    error_locations = bitstreamtoimage(error_locations, imageSize, bitsPerPixel);
    % Plot images
    figure(1);
    subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
    subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
    
        
    figure(5)
    imagesc(error_locations);
end
