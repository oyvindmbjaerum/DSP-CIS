impulse_response_length = 100;
causality_margin = 5;


input_noise_start = fs*2 - causality_margin;

input_noise = white_noise_recorded(input_noise_start : input_noise_start + impulse_response_length, 1);
threshold = 0.03;
indices_noise_starts = find(abs(diff(out)) > threshold)


output_noise = out(indices_noise_starts(1) : indices_noise_starts(1) +  impulse_response_length  - causality_margin +1);


toep_input = toeplitz(input_noise(causality_margin:end), flip(input_noise(1:impulse_response_length)));


h = lsqr(toep_input, output_noise)


save('IRest.mat','h');

ynew = conv(input_noise, h);


[freq_response, angular_freqs]  = freqz(h, 1,32, fs);



%%
figure(4);
subplot(2, 1, 1);

stem(h);
title("Time response of estimated impulse response");
xlabel('Samples');

subplot(2, 1, 2);

plot(angular_freqs,20*log10(abs(freq_response)))
title("Frequency response of estimated impulse response");
xlabel('Frequency (HZ)');
ylabel('Frequency response magnitude(dB)');