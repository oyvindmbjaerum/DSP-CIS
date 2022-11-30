function[serialised_packet, full_size_packet] = ofdm_mod(qam_stream, trainblock, fft_size, L, mask, n_training_frames, n_data_frames)
    on_carriers = find(mask == 1);
    
    %Calculating number of frames needed for entire stream
    number_of_data_frames = ceil(length(qam_stream)/(length(on_carriers)));
    n_training_pauses = ceil(number_of_data_frames/n_data_frames);
    number_of_frames = number_of_data_frames + n_training_pauses*n_training_frames;


    %Reshape the qam_stream so you can easily insert into packet matrix
    padded_qam_stream = zeros(number_of_data_frames*length(on_carriers), 1);
    padded_qam_stream(1:length(qam_stream)) = qam_stream;
    padded_qam_stream = reshape(padded_qam_stream, length(on_carriers), number_of_data_frames);

    %Insert values only into carriers that are used
    data_packet = zeros(length(mask), number_of_data_frames);
    for i = 1 : number_of_data_frames
        
        data_packet( :,i) = padded_qam_stream( :,i);
    end
    
    %Inserting training values only into used carriers
    training_packet = zeros(fft_size/2 -1, 1);
    training_packet(on_carriers) = trainblock(on_carriers);
    
    %Creating matrix we will be inserting our frames into
    full_size_packet = zeros(fft_size, number_of_frames);
    
    
    n_data_frames_used = 1; %Start at 1 because of 1-indexing in matlab

    for k = 1:number_of_frames
        if  ismember(mod(k, n_training_frames + n_data_frames), linspace(1, n_training_frames, n_training_frames)) %Add training frame
            frame_firsthalf =  training_packet;

        else %Add data frame
            frame_firsthalf =  data_packet(:,n_data_frames_used);

            n_data_frames_used = n_data_frames_used + 1;
        end

        frame_secondhalf = flip(conj(frame_firsthalf));
        full_size_packet(:,k) = [0, frame_firsthalf.',  0, frame_secondhalf.'];
    end

    %Modulate to time domain so the package can be sent over the channel
    ifft_packet = ifft(full_size_packet, fft_size, 1); 

    %Adding a cyclic prefix
    padded_packet = zeros(size(ifft_packet, 1) + L, size(ifft_packet, 2));
    padded_packet(L+1:end,:) = ifft_packet;
    padded_packet(1:L,:) = ifft_packet(end - L + 1:end,:);
    
    serialised_packet = reshape(padded_packet, [], 1);
end