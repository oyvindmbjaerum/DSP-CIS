% Exercise session 4: DMT-OFDM transmission scheme


function   [berTransmission, ratio, error_locations] = main(frame_length, M, L, snr, channel_constants)
    
    
    % Convert BMP image to bitstream
    [bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

    % QAM modulation
    qamStream = qam_mod(bitStream, M);
    
    % OFDM modulation
    ofdmStream = ofdm_mod(qamStream, frame_length, L);
    
    % Channel
    rxOfdmStream = awgn(ofdmStream, snr);
   
    %rxOfdmStream =  conv(channel_constants, ofdmStream);
    
    % OFDM demodulation
    rxQamStream = ofdm_demod(rxOfdmStream, frame_length, L, channel_constants); %(1:end - (length(channel_constants) -1),:)
    
    % QAM demodulation
    rxBitStream = qam_demod(rxQamStream, M);
    
    rxBitStream = rxBitStream(1:length(bitStream)); %rem(length(full_bitstream), length(bitStream))

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
