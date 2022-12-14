function [decoded_qam_symbols, W, Error] = ofdm_demod(received_stream, fft_size, L, mask, trainblock, n_training_frames, n_data_frames, step_size, M, best_guess)
    on_carriers = find(mask == 1);
    %When running signal through acoustic channel you get a varied amount
    %of samples, zero pad the received stream so it fits in an amount of
    %frames

    n_frames = ceil(length(received_stream)/(fft_size + L));

    received_stream(n_frames*(fft_size + L)) = 0;

    %Demodulate the OFDM signal
    received_stream = reshape(received_stream, fft_size + L, []);
    clipped_stream = received_stream(L + 1:end,:); %remove cyclic prefix
    
    fft_packet = fft(clipped_stream, fft_size, 1);
    fft_packet = fft_packet(2 : fft_size/2, :);
    initial_channel_guess = 0.1 + 1i*0.1;
    delta = 0.01; %tolerance 
    

    alpha = 0.000000001;



    if n_training_frames > 0 % If you are estimating channel
        decoded_qam_symbols = zeros(fft_size/2 - 1, n_training_frames);
        W = zeros(fft_size/2 - 1, 1 + n_training_frames);
        W(:, 1) = (1/conj(initial_channel_guess))  + delta;
        Error = zeros(fft_size/2 - 1, n_training_frames);
        
        for i = 1 : n_training_frames
                Y =  fft_packet(:, i);
                decoded_qam_symbols(:, i) = conj(W(:, i)) .* Y;

                Error(:, i) = (trainblock - decoded_qam_symbols(:, i)); %Compare result with training block

                W(:, i + 1) = W(:, i) + (step_size ./ (alpha + conj(Y) .* Y)) .*  Y .* conj(Error(:, i));
        end

    else %If you are receiving data
        decoded_qam_symbols = zeros(fft_size/2 - 1, n_frames);
        W = zeros(fft_size/2 - 1, 1 + n_frames);
        W(:,  1) = best_guess;
        Error = zeros(fft_size/2 - 1, n_frames);
        for i = 1 : n_frames
            Y =  fft_packet(:, i);
            decoded_qam_symbols(:, i) =  conj(W(:, i)) .* Y; 
            bits = qam_demod(decoded_qam_symbols(:, i), M); %Compare result with estimate
            X_desired = qam_mod(bits, M);         
            Error(:, i) = (X_desired - decoded_qam_symbols(:, i));

            W(:, i + 1) = W(:, i) + (step_size ./ (alpha + conj(Y) .* Y)) .*  Y .* conj(Error(:, i));
        end
    end 

    decoded_qam_symbols = decoded_qam_symbols(on_carriers, :);
end