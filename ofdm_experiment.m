P = 16;
N = 4;
nfft = 16

M = 16;
x = (0:M-1);


binary_sequence = de2bi(x, 'left-msb');

packet = reshape(binary_sequence.',1,[]);

frame_firsthalf = qam_mod(packet.', M);

frame_secondhalf = conj(flip(frame_firsthalf));

frame = [0,frame_firsthalf.',0,frame_secondhalf.'].';

%%mod_frame = ofdm_mod(frame, nfft, )
