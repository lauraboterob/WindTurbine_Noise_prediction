function [AoA_dist,U_dist,Re_dist] = find_AL_data_distr(blade,AL_file)
Ra_dist_final = blade.Ra_dist_final;
[R_dist_AL,AoA_dist_AL,V_app_dist_AL,Re_dist_AL] = Read_AL_inst_simulations(AL_file);
    for count = 1:length(Ra_dist_final)
     % interpolate to find the BEM parameters at Ra
                pos = find(diff(sign(Ra_dist_final(count)-R_dist_AL)))+1;
                if pos == 2
                   [AoA_dist(count)] = interp_values_AL(AoA_dist_AL(1),AoA_dist_AL(2),R_dist_AL(1),R_dist_AL(2),Ra_dist_final(count));
                   [Re_dist(count)] = interp_values_AL(RE_dist_AL(1),Re_dist_AL(2),R_dist_AL(1),R_dist_AL(2),Ra_dist_final(count));
                   [U_dist(count)] = interp_values_AL(V_app_dist_AL(1),V_app_dist_AL(2),R_dist_AL(1),R_dist_AL(2),Ra_dist_final(count));
                else 
                    [AoA_dist(count)] = interp_values_AL(AoA_dist_AL(pos-1),AoA_dist_AL(pos),R_dist_AL(pos-1),R_dist_AL(pos),Ra_dist_final(count));
                    [Re_dist(count)] = interp_values_AL(Re_dist_AL(pos-1),Re_dist_AL(pos),R_dist_AL(pos-1),R_dist_AL(pos),Ra_dist_final(count));
                    [U_dist(count)] = interp_values_AL(V_app_dist_AL(pos-1),V_app_dist_AL(pos),R_dist_AL(pos-1),R_dist_AL(pos),Ra_dist_final(count));
                end 
    end 
end

