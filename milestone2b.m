frame_length = 2003;
M = 32; %Constellation size
L = 16; %length of cyclic prefix

snr = 5000000000;
ir_estimate = load("IRest.mat");

[berTransmission, ratio, error_locations] = main(frame_length, M, L, snr, ir_estimate.h);
