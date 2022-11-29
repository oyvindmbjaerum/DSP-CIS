function [simin, nbsecs, fs, pulse] = initparams(toplay, fs, impulse_response_length)
    sync_x = linspace(-2000, 2000);
    pulse = sinc(sync_x);
    pulse = rescale(pulse, -1,1);
    


    toplay = rescale(toplay, -1,1);
    simin = zeros(2*fs + length(toplay) + fs + length(pulse) + impulse_response_length, 2); % Adding 2 seconds of silence at the start and one at the end
    
    simin(2*fs : 2*fs +  length(pulse) -1) = pulse;
    
    simin(2*fs +  length(pulse) + impulse_response_length : 2*fs+length(toplay) + length(pulse) + impulse_response_length - 1) = toplay.'; % fill values of toplay after 2 seconds of silence
    nbsecs = length(simin)/fs + 1; %Let the nbsecs be 1 second longer than input signal          
end