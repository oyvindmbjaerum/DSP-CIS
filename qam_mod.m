
function [constellation] = qam_mod(randomsequence, M)
    constellation = qammod(randomsequence, M, 'InputType','bit','UnitAveragePower',true);
end