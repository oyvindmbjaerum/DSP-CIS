
fs = 16000;
N = 1024;
W = rectwin(N);
overlap = 512;
impulse = [1];

taps = 0 : fs*4 + 255;
[simin,nbsecs,fs] = initparams(impulse,fs);
sim('recplay');


clf;

out=simout.signals.values;

%%
% impulse_response = impzest(impulse', out);
% 
% plot(taps, impulse_response)
% 
%taps = taps(end - 70000:end);
%out = out(end - 70000:end);
figure(1);
subplot(2, 1, 1);
stem(taps, out) ;
subplot(2, 1, 2);
pwelch( out, N, overlap, N, fs);