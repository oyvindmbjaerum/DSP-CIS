function [left_scalars, right_scalars, h_combined] = fixed_transmitter_side_beamformer(left_impulse_response, right_impulse_response)
    left_transfer_function = fft(left_impulse_response);
    right_transfer_function = fft(right_impulse_response);
    h_combined = (sqrt((left_transfer_function .* conj(left_transfer_function)) + (right_transfer_function .* conj(right_transfer_function))));

    left_scalars = conj(left_transfer_function) ./ h_combined;
    right_scalars = conj(right_transfer_function) ./ h_combined;
end