function [demodulated_sequence] = qam_demod(symbol_sequence, M)
demodulated_sequence = qamdemod(symbol_sequence, M,'bin','OutputType','bit',UnitAveragePower = true);
end 