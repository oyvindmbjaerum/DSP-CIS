% Exercise session 4: DMT-OFDM transmission scheme


M = 32;


% Convert BMP image to bitstream
[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

% QAM modulation
qamStream = qam_mod(bitStream, M);

% OFDM modulation
ofdmStream = qamStream;

% Channel
rxOfdmStream = ofdmStream;

% OFDM demodulation
rxQamStream = rxOfdmStream;

% QAM demodulation
rxBitStream = qam_demod(rxQamStream, M);

% Compute BER
[berTransmission, ratio] = ber(bitStream,rxBitStream);

% Construct image from bitstream
imageRx = bitstreamtoimage(rxBitStream, imageSize, bitsPerPixel);

% Plot images
subplot(2,1,1); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;
subplot(2,1,2); colormap(colorMap); image(imageRx); axis image; title(['Received image']); drawnow;
