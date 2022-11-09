constellation_sizes = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048];
snr_values = -20:1:50;

bit_error_rates = zeros(length(snr_values), length(constellation_sizes));

for i = 1: length(constellation_sizes)
    for j = 1: length(snr_values)
        bit_error_rates(j,i) = qam_experiment(constellation_sizes(i), snr_values(j));
    end
    figure(i)
    plot(snr_values, bit_error_rates(:,i));
    title(["Bit error rate as function of SNR with QAM constellation size", num2str(constellation_sizes(i))]);
    xlabel("SNR [dB]");
    ylabel("Bit error rate");
end



error_rate = qam_experiment(2, 0)

%figure(4)
%plot(snr_values, bit_error_rates(1,:));
