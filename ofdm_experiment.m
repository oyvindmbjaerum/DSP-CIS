frame_length = 1025; %Errors seem to go up when frame length goes down, or maybe that its just a fixed number of errors (10 , 30)
M = 32;
L = 30; %length of cyclic prefix
k = log2(M);
number_of_frames = 32;
x = randi([0 1],number_of_frames*frame_length*k,1);
ir_length = 24;
channel_constants = rand(ir_length, 1);

pow2(ceil(log2(frame_length)))

symbol_sequence = qam_mod(x, M);

finished_packet = ofdm_mod(symbol_sequence, frame_length, L);



channel_constants = rand(ir_length, 1);
finished_packet =  conv(channel_constants, finished_packet);


decoded_symbols = ofdm_demod(finished_packet(1:end - ir_length + 1,:), frame_length, L, channel_constants);

decoded_bits = qam_demod(decoded_symbols, M);

[errors, error_rate] = ber(x, decoded_bits)

freq_response = fft(channel_constants, pow2(ceil(log2(frame_length))), 1);
P2 = abs(freq_response/pow2(ceil(log2(frame_length))));
P2 = P2';
P1 = P2(:,1:pow2(ceil(log2(frame_length)))/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1); %Change to magnitude by squaring

P1db = mag2db(P1);
f = fs*(0:(pow2(ceil(log2(frame_length)))/2))/pow2(ceil(log2(frame_length)));

figure(3)
plot(P1db);