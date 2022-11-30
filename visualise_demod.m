%Do stuff needed to loop nicely through packets
n_packets = length(Tx)/((fft_size + L)*(n_data_frames + n_training_frames)); %This will only work if number of frames are nicely divisible by frames in packet
on_carriers = find(mask == 1);
bitstream_length = n_packets * k * length(on_carriers)*n_data_frames;
rx_bit_stream = rx_bit_stream(1: bitstream_length);
empty_image_bit_stream = zeros(bitstream_length, 1);


imageRx = bitstreamtoimage(empty_image_bit_stream, imageSize, bitsPerPixel);

figure(1);
subplot(2,2,2); colormap(colorMap); image(imageData); axis image; title('Original image'); drawnow;


for i = 1 : n_packets
    tic;

    empty_image_bit_stream((i - 1) * bitstream_length/n_packets + 1: i * bitstream_length/n_packets) = rx_bit_stream((i - 1) * bitstream_length/n_packets + 1: i * bitstream_length/n_packets);
    imageRx = bitstreamtoimage(empty_image_bit_stream, imageSize, bitsPerPixel);
    figure(1);
    subplot(2, 2, 1);
    stem(ifft(channel_est(:, i))); title('Estimated channel impulse response'); ylim([-1.1 1.1]);
    
    %Calculating freq response
    L = length(channel_est(:, i));
    P2 = abs(channel_est(:, i)/L);
    P2 = P2';
    P1 = P2(:,1:L/2+1);
    P1(:,2:end-1) = 2*P1(:,2:end-1); %Change to magnitude by squaring
    
    P1db = mag2db(P1);
    f = fs*(0:(L/2))/L;
    
    subplot(2, 2, 3);
    plot(f, P1db); title('Estimated channel frequency response');xlabel('Frequency (Hz)'); ylabel('Frequency response magnitude(dB)'); ylim([-80 0]);
    
    
    subplot(2,2,4); colormap(colorMap); image(imageRx); axis image; title('Received image'); drawnow;
    plotting_time = toc;

    pause(transmission_time/n_packets - plotting_time);
end
