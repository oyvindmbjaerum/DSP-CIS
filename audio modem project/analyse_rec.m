
clf;


fs = 16000;
N = 1024;
W = 512;
overlap = 256;


test_playrec;
%%
out=simout.signals.values;

%sound(out, fs);

figure(1);
%spectrogram
subplot(2, 1, 1);
s = spectrogram(out,  W, overlap, N);



subplot(2, 1, 2);
[s2, f2, t2] = spectrogram(simin(:,1),  W, overlap, N, fs);



% %PSD
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
% figure(2);
% subplot(2, 1, 1);
% plot(freq_in, pow2db(in_psd));
% 
% subplot(2, 1, 2);
% plot(freq_out, pow2db(out_psd));
