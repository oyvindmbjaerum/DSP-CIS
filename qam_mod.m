
function [modulated_sequence] = qam_mod(bit_sequence, M)
    modulated_sequence = qammod(bit_sequence, M,"bin",  'InputType','bit','UnitAveragePower',true);
end