
fs = 16000;

freq_1 = 100;
freq_2 = 200;
freq_3 = 500;
freq_4 = 1500;
freq_5 = 2000;
freq_6 = 4000;
freq_7 = 6000;

ts = 1/fs;
T = 2;
t=0:ts:T;
%sine_wave =  sin(2*pi*freq_4*t);
%sine_wave = 0.5 +  sin(2*pi*400*t);
sine_wave =  sin(2*pi*freq_1*t)+ sin(2*pi*freq_2*t) + sin(2*pi*freq_3*t) + sin(2*pi*freq_4*t) + sin(2*pi*freq_5*t) + sin(2*pi*freq_6*t) + sin(2*pi*freq_7*t);

%[simin,nbsecs,fs] = initparams(sine_wave,fs);


noise = wgn(fs*2,1,0);

[simin,nbsecs,fs] = initparams(noise,fs);
sim('recplay');

function [simin, nbsecs, fs] = initparams(toplay, fs)
    toplay = rescale(toplay, -1,1);
    simin = zeros(2*fs + length(toplay) + fs, 2); % Adding 2 seconds of silence at the start and one at the end
    simin(2*fs : 2*fs+length(toplay) -1, 1) = toplay.'; % fill values of toplay after 2 seconds of silence
    nbsecs = length(simin)/fs + 1; %Let the nbsecs be 1 second longer than input signal
    fs;           
end
    