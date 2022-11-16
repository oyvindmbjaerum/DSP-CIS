clf;

fs = 16000;
N = 1024;
W = rectwin(N);
overlap = 512;
test_playrec;

out=simout.signals.values;

%sound(out, fs);

%%
%Spectrogram calculation and plotting
figure(1); 
subplot(2, 1, 1);
spectrogram(out,  W, overlap, N,fs, 'yaxis');
title("Spectrogram of recorded signal")
subplot(2, 1, 2);
spectrogram(simin(:,1),  W, overlap, N, fs, 'yaxis');
title("Spectrogram of input signal")


figure(2);
Hs = spectrum.periodogram('Bartlett');
subplot(2, 1, 1);
pwelch(out, N, overlap, N, fs);
title("PSD of recorded signal")
subplot(2, 1, 2);
pwelch( simin(:,1), N, overlap, N, fs);
title("PSD of input signal")




% %%
% %PSD old
% in_fft = fft(simin(:,1));
% in_len = length(in_fft);
% in_fft = in_fft(1 : in_len/2 + 1);
% in_psd = (1/(fs*in_len))*abs(in_fft).^2;
% 
% in_psd(2 : end-1) = 2*in_psd(2 : end-1);
% freq_in = 0 : fs/in_len : fs/2;
% 
% out_fft = fft(out);
% out_len = length(out_fft);
% out_fft = out_fft(1 : out_len/2 + 1);
% out_psd = (1/(fs*out_len))*abs(out_fft).^2;
% 
% out_psd(2 : end-1) = 2*out_psd(2 : end-1);  
% freq_out = 0 : fs/out_len : fs/2;
% 
% 
% figure(3);
% subplot(2, 1, 1);
% plot(freq_in, pow2db(in_psd));
% 
% subplot(2, 1, 2);
% plot(freq_out, pow2db(out_psd));
% 
% %%
% %For plotting with only periodogram no smoothing
% figure(4);
% w = bartlett(length(out));
% subplot(2, 1, 1);
% periodogram(out, w, N, fs);
% subplot(2, 1, 2);
% w = bartlett(length(simin(:,1)));
% periodogram(simin(:,1), w, N, fs);
% 
% %%
% %Welch's method
% figure(5);
% subplot(2, 1, 1);
% pwelch(out, N, overlap, N, fs);
% subplot(2, 1, 2);
% pwelch( simin(:,1), N, overlap, N, fs);
