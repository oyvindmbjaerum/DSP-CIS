function [demodulated_sequence] = qam_demod(symbol_sequence, M)
    if isvector(symbol_sequence)
        demodulated_sequence = qamdemod(symbol_sequence, M, 'bin', 'OutputType', 'bit', UnitAveragePower = true);
    else
        demodulated_sequence = zeros(size(symbol_sequence, 1)*log2(M), size(symbol_sequence, 2));
        for i = 1 : size(symbol_sequence, 2)
        demodulated_sequence(:,i) = qamdemod(symbol_sequence(:,i), M, 'bin', 'OutputType', 'bit', UnitAveragePower = true);
        end
        demodulated_sequence = reshape(demodulated_sequence, [], 1);
    end
end 