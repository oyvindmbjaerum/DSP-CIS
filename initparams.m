function [simin, nbsecs, fs, pulse] = initparams(toplay, fs, impulse_response_length)
    sync_x = linspace(0, 1000, 1000);
    pulse = sawtooth(sync_x);
    pulse = rescale(pulse, -1,1);
    
    pad_seconds_before = 4;
    pad_seconds_after = 2;

    toplay = rescale(toplay, -1,1);
    simin = zeros(pad_seconds_before*fs + length(toplay) + pad_seconds_after*fs + length(pulse) + impulse_response_length, 2); % Adding 2 seconds of silence at the start and one at the end
    
    simin(pad_seconds_before*fs : pad_seconds_before*fs +  length(pulse) -1) = pulse;
    
    simin(pad_seconds_before*fs +  length(pulse) + impulse_response_length : pad_seconds_before*fs+length(toplay) + length(pulse) + impulse_response_length - 1) = toplay.'; % fill values of toplay after padded silence before signal
    nbsecs = length(simin)/fs + 5; % + pad_seconds_after; %Let the nbsecs be longer than input signal        
end