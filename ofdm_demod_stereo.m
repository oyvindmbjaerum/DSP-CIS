function [decoded_qam_symbols, channel_est] = ofdm_demod_stereo(received_stream, fft_size, L, mask, trainblock, n_training_frames, n_data_frames)
    %When running signal through acoustic channel you get a varied amount
    %of samples, zero pad the received stream so it fits in an amount of
    %frames

    n_frames = ceil(length(received_stream)/(fft_size + L));

    received_stream(n_frames*(fft_size + L)) = 0;

    %Demodulate the OFDM signal
    received_stream = reshape(received_stream, fft_size + L, []);
    clipped_stream = received_stream(L + 1:end,:); %remove cyclic prefix
    
    fft_packet = fft(clipped_stream, fft_size, 1);
    
    %Empty arrays to fill our channel estimations and QAM symbols with
    channel_est = [];
    qam_symbols = [];

    padded_trainblock = [0, trainblock.', 0, flip(conj(trainblock)).'].';
    train_mat = repmat(padded_trainblock, 1, n_training_frames);

    for k = 1 : size(fft_packet, 2)
        
        if  mod(k, n_training_frames + n_data_frames) == n_training_frames %Working on the last sequence of training frames
            %Estimating the frequency response of the channel
            h_est = zeros(fft_size, 1);
            for i = 2 : length(padded_trainblock)/2 %Only looping through carriers holding data
                h_est(i) = train_mat(i, :).' \ fft_packet(i, k - (n_training_frames - 1) : k).';         
            end
            
            h_est(fft_size/2 + 2 : end) = conj(flip(h_est(2:fft_size/2)));
            channel_est = [channel_est h_est];


        elseif mod(k, n_training_frames + n_data_frames) > n_training_frames || mod(k, n_training_frames + n_data_frames) == 0  %Ddemodulating data frame
            channel_freq_response = 1 ./ channel_est(:, end);
            qam_symbols = [qam_symbols (fft_packet(:, k) .* channel_freq_response)];
        end
    end
    
    %Getting the data from the packet out
    decoded_qam_symbols = qam_symbols(2:fft_size/2, :);
end