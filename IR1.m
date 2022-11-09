fs = 16000;
N = 1024;
W = rectwin(N);
overlap = 512;
impulse = [1];

[simin,nbsecs,fs] = initparams(impulse,fs);
sim('recplay');

impulse_out=simout.signals.values;

%%
scale_factor = 0.7;
max_index = find(impulse_out == max(impulse_out));
threshold = max(impulse_out) * scale_factor;


indices = find(abs(impulse_out) > threshold);

b = indices( 1:find( indices > 1000, 1 ) );
response_start_index = b(1);


clipped_impulse_response = impulse_out(response_start_index: response_start_index +  impulse_response_length);

freq_response = fft(clipped_impulse_response);
L = length(clipped_impulse_response);
P2 = abs(freq_response/L);
P2 = P2';
P1 = P2(:,1:L/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1); %Change to magnitude by squaring

P1db = mag2db(P1);
f = fs*(0:(L/2))/L;


figure(3);
subplot(2, 1, 1);
stem(clipped_impulse_response);
title("Response of recorded impulse signal")
xlabel('Samples')

subplot(2, 1, 2);
plot(f,P1db); 
title("Frequency response of impulse signal")
xlabel("f (Hz)")
ylabel("Frequency response magnitude (dB)")


figure(6);
plot(impulse_out)