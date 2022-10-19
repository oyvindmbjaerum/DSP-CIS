
fs = 16000;
N = 1024;
W = rectwin(N);
overlap = 512;
t = 0 : 1/fs : 5;

taps = 0 : fs*9 +127;
impulse = t==2.49993750000000;
impulse = double(impulse);

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
subplot(2, 1, 1);
plot(taps, out) ;
subplot(2, 1, 2);
pwelch( out, N, overlap, N, fs);