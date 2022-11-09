impulse_response_length = 31;
causality_margin = 5;


input_noise_start = fs*2 - causality_margin;

input_noise = simin(input_noise_start : input_noise_start + impulse_response_length, 1);
threshold = 0.03; %Bespoke limit
indices_noise_starts = find(abs(diff(out)) > threshold)


output_noise = out(indices_noise_starts(1):indices_noise_starts(1)+  impulse_response_length);


toep_input = toeplitz(input_noise);

h = output_noise' * inv(toep_input);


save('IRest.mat','h');


%%
[freq_response, angular_freqs]  = freqz(h, 1, 32, fs);



%%
figure(4);
subplot(2, 1, 1);

stem(h);
title("Response of estimated impulse response");
xlabel('Samples');

subplot(2, 1, 2);

plot(angular_freqs,20*log10(abs(freq_response)))
title("Frequency response of estimated impulse response");
xlabel('Frequency (HZ)');
ylabel('Frequency response magnitude(dB)');