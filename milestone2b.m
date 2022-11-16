frame_length = 1024;
M = 2; %Constellation size
L = 64; %length of cyclic prefix
fs = 16000;
fft_size = pow2(ceil(log2(frame_length)));
snr = 1000000000000;
ir_estimate = load("IRmeas.mat");

[berTransmission, ratio, error_locations] = main(frame_length, M, L, snr, ir_estimate.clipped_impulse_response);


figure(10)
% freq_response = fft(ir_estimate.clipped_impulse_response, fft_size)
% L = length(ir_estimate.clipped_impulse_response);
% P2 = abs(freq_response/L);
% P2 = P2';
% P1 = P2(:,1:L/2+1);
% P1(:,2:end-1) = 2*P1(:,2:end-1); %Change to magnitude by squaring
% 
% P1db = mag2db(P1);
% f = fs*(0:(L/2))/L;
% plot(f, P1db);