fs = 16000;
fft_size = 1024; %same as frame length

n_symbols = fft_size/2 -1;
M = 4;
L = 16;

n_training_frames = 0;
n_data_frames = 5;


k = log2(M);
training_bits = randi([0 1], n_symbols*k,1);

mask = ones(fft_size/2 - 1, 1);
trainblock = qam_mod(training_bits, M); 



[bitStream, imageData, colorMap, imageSize, bitsPerPixel] = imagetobitstream('image.bmp');

qamStream = qam_mod(bitStream, M);


