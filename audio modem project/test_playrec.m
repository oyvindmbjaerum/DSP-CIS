
fs = 16000;

sine_freq = 1500;
ts = 1/fs;
T = 2;
t=0:ts:T;
sine_wave = sin(2*pi*sine_freq*t);

[simin,nbsecs,fs] = initparams(sine_wave,fs);


sim('recplay');

function [simin, nbsecs, fs] = initparams(toplay, fs)
    
    simin = zeros(2*fs + length(toplay) + fs, 2); % Adding 2 seconds of silence at the start and one at the end
    simin(2*fs : 2*fs+length(toplay) -1, 1) = toplay.'; % fill values of toplay after 2 seconds of silence
    nbsecs = length(simin)/fs + 1; %Let the nbsecs be 1 second longer than input signal
    fs;           
end
    