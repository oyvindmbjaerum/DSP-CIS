
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


    