frame_length = 1024; %Errors seem to go up when frame length goes down, or maybe that its just a fixed number of errors (10 , 30)
M = 32;
L = 16; %length of cyclic prefix
k = log2(M);
number_of_frames = 32;
x = randi([0 1],number_of_frames*frame_length*k,1);




