function [used_carriers] = on_off_mask(channel_freq_response, fft_size, bw_usage)
    n_used_carriers = ceil(bw_usage / 100 * (fft_size/2 - 1));

    L = length(channel_freq_response);
    P2 = abs(channel_freq_response/L);
    P2 = P2';
    P1 = P2(:,1:L/2+1);
    P1(:,2:end-1) = 2*P1(:,2:end-1); %Change to magnitude by squaring
    
    P1db = mag2db(P1);

    [sorted_carriers, indices] = sort(P2(2: fft_size/2));
    indices = flip(indices);
    one_indices = indices(1:n_used_carriers);
    

    used_carriers = zeros(fft_size/2 - 1, 1);
    for i = 1 : length(one_indices)
        used_carriers(one_indices(i)) = 1;
    end

end