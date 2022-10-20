fs = 16000;
N = 1024;
W = rectwin(N);
overlap = 512;

impulse_response_length = 5; % maybe we need to fix this
impulse = wgn(impulse_response_length*2 + 1, 1, 0);
%impulse(1) = 1; % Put the first stem to 1 because we want causality



[simin,nbsecs,fs] = initparams(impulse,fs);
sim('recplay');
out=simout.signals.values;
%%
MAX = find(out == max(out));

clipped_impulse_response = out(MAX - impulse_response_length : MAX + impulse_response_length);

h = clipped_impulse_response/impulse;


h = toeplitz(h);
save('IRest.mat','h');
%%
figure(2);
subplot(2, 1, 1);
stem(out);
subplot(2, 1, 2);
pwelch( out, N, overlap, N, fs);

