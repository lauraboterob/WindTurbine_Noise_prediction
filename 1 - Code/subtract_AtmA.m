function [S_pp_total] = subtract_AtmA(S_pp_total,a,dist)
S_pp_total_db = 10*log10(S_pp_total) - a.*dist;
S_pp_total = 10.^(S_pp_total_db/10);
end

