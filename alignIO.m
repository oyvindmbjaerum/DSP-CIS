function [out_aligned, estimated_lag] = alignIO(out, pulse, impulse_response_length) 
    [correlations,lags] = xcorr(out,pulse);
    
    [maximum_corr,max_idx] = max(correlations);

    safety_margin = 20;

    estimated_lag = lags(max_idx);

    %Negative lag means shift out to the right, zero padding at the start
    %of the vector, positive lag means shift out to the left, cutting
    %values at the start

    if estimated_lag < 0
        out_aligned = zeros(length(out) + abs(estimated_lag), 1);
        out_aligned(abs(estimated_lag): end) = out;

    elseif estimated_lag > 0
        out_aligned = out(estimated_lag : end);
        
    else 
        out_aligned = out;
    
    end

    %Cut off the synchronisation pulse and zeros for making sure sync pulse
    %does not bleed into signal
    out_aligned = out_aligned( impulse_response_length + length(pulse)/2  - safety_margin : end); %Half the length of the sync pulse because it is symmetrical

    
end