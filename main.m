% Exercise session 4: DMT-OFDM transmission scheme


function   [berTransmission, ratio, error_locations] = main(frame_length, M, L, snr, channel_constants)
    
    mask = on_off_mask(channel_constants, frame_length);

    mask = ones(length(mask), 1); %Comment out this line if you want to use ON-OFF bitloading, goes from ber 0,2 to 0,3 is that right?
    
    % Convert BMP image to bitstream
    [bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

    % QAM modulation
    qamStream = qam_mod(bitStream, M);
    
    % OFDM modulation
    ofdmStream = ofdm_mod(qamStream, frame_length, L, mask);
    
    % Channel
    rxOfdmStream = awgn(ofdmStream, snr);
   
    %rxOfdmStream =  conv(channel_constants, rxOfdmStream);
    
    % OFDM demodulation
    rxQamStream = ofdm_demod(rxOfdmStream, frame_length, L, channel_constants, mask); %(1:end - (length(channel_constants) -1),:)
    
    % QAM demodulation
    rxBitStream = qam_demod(rxQamStream, M);
    
    rxBitStream = rxBitStream(1:length(bitStream)); %Removes the extra bits that were needed to have N full frames of QAM symbols

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
