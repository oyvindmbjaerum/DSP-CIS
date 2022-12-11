%clf; 
close all;

n_symbols = 100;
M = 64;
k = log2(M);
snr = inf; %10 dB SNR
step_sizes = linspace(0.1, 1.8, 10);
delta = 1.5;
alpha = 0.000001;

H = 0.3 + 1i * 0.7;


training_bits = randi([0 1], n_symbols*k,1);

X = qam_mod(training_bits, M);

for j = 1 : length(step_sizes)
    W = 1/conj(H);
    W = W*delta
    W_vec = [];
    Error_vec = [];
    for i = 1 : length(X)
        received_signal = X(i) * (H);
        
        Y = awgn(received_signal, snr);
        
        X_comped = Y * conj(W);
        
        bits = qam_demod(X_comped, M);
        X_desired = qam_mod(bits, M);
        
        Error = (X_desired - X_comped);
        
        W_new = W + (step_sizes(j)/(alpha + conj(Y) * Y)) *  Y * Error';
    
        W = W_new;
    
        disp(W);
    
        W_vec = [W_vec W];
        Error_vec = [Error_vec Error];
    end
    %%
    hold on
    figure(1);
    plot(abs(W_vec)); ylim([0, 2]);
    
    
    figure(2);
    plot(abs(Error_vec));
    W_ideal = 1/conj(H)
    hold off
end