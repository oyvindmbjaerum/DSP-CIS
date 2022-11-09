


frame_length = 1024; %Errors seem to go up when frame length goes down, or maybe that its just a fixed number of errors (10 , 30)
M = 16;
L = 16; %length of cyclic prefix
k = log2(M);
number_of_frames = 32;
x = randi([0 1],number_of_frames*frame_length*k,1);



finished_packet = ofdm_mod(x, M, frame_length, L);

decoded_symbol = ofdm_demod(finished_packet, M, frame_length, L);

[errors, error_rate] = ber(x, reshape(decoded_symbol, [], 1))