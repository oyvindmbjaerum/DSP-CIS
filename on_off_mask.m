function [one_indices] = on_off_mask(channel_response, frame_length)
    fft_size = pow2(ceil(log2(frame_length)));
    freq_response = fft(channel_response, fft_size);
    freq_response = abs(freq_response);
    one_indices = freq_response < 1; %Should it be > or < for the limit if we should use the n-th carrier
end