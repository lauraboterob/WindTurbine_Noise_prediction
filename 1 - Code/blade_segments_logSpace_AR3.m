function [c_dist_final, Ra_dist_final, twist_dist_final, airfoil_dist_final, AoA_dist,b_dist,U_dist,Re_dist] = blade_segments_logSpace_AR3(input)
airfoil_dist_final = [];
[R_dist,c_dist,~,twist_dist,airfoil_dist] = Read_bladeinputs();
[R_dist_AL,AoA_dist_AL,V_app_dist_AL] = Read_AL_simulations();
%% Stablish radial positions
theta = linspace(0,90,input.n+2);
delta = (input.radio-input.innitial_ratio )*cosd(theta); 
radial_positions = input.innitial_ratio  + flip(delta(1:end));
count = 1;
radial_positions_inn = radial_positions(count);
for i = 1:(input.n-1)
    b_dist(count) = radial_positions(i+1) - radial_positions_inn;
    Ra_dist_final(count)  =radial_positions_inn + b_dist(count)/2;
    pos_r = find(diff(sign(Ra_dist_final(count) - R_dist)))+1;
                if pos_r == 2
               % interpolate the geometrical parameters at Ra
                a_int = [c_dist(1) c_dist(2)];
                b_int = [R_dist(1)  R_dist(2)];
                c_fit = polyfit(b_int,a_int,1);    
                c_dist_final(count) = c_fit(1)*Ra_dist_final(count)  + c_fit(2);
                a_int = [twist_dist(1) twist_dist(2)];
                b_int = [R_dist(1)  R_dist(2)];
                twist_fit = polyfit(b_int,a_int,1);    
                twist_dist_final(count) = twist_fit(1)*Ra_dist_final(count)  + twist_fit(2);
                airfoil_dist_pos =  airfoil_dist(1);
                else 
                 if isempty(pos_r)
                    airfoil_dist_pos =  airfoil_dist(end);
                    c_dist_final(count) = c_dist(end);
                    twist_dist_final(count) = twist_dist(end);
                 else 
                airfoil_dist_pos =  airfoil_dist(pos_r-1);
                % interpolate the geometrical parameters at Ra
                a_int = [c_dist(pos_r-1) c_dist(pos_r)];
                b_int = [R_dist(pos_r-1)  R_dist(pos_r)];
                c_fit = polyfit(b_int,a_int,1);    
                c_dist_final(count)  = c_fit(1)*Ra_dist_final(count)  + c_fit(2);
                a_int = [twist_dist(pos_r-1) twist_dist(pos_r)];
                b_int = [R_dist(pos_r-1)  R_dist(pos_r)];
                twist_fit = polyfit(b_int,a_int,1);    
                twist_dist_final(count) = twist_fit(1)*Ra_dist_final(count)  + twist_fit(2);
                 end 
            end     
                % interpolate to find the aerodynamic parameters at Ra
                pos = find(diff(sign(Ra_dist_final(count)-R_dist_AL)))+1;
                if pos == 2
                   [AoA_dist(count)] = interp_values_AL(AoA_dist_AL(1),AoA_dist_AL(2),R_dist_AL(1),R_dist_AL(2),Ra_dist_final(count));
                   [U_dist(count)] = interp_values_AL(V_app_dist_AL(1),V_app_dist_AL(2),R_dist_AL(1),R_dist_AL(2),Ra_dist_final(count));
                   Re_dist(count) = c_dist_final(count)*U_dist(count)*1.2/1.81*10^-5;  
                else 
                    [AoA_dist(count)] = interp_values_AL(AoA_dist_AL(pos-1),AoA_dist_AL(pos),R_dist_AL(pos-1),R_dist_AL(pos),Ra_dist_final(count));
                    [U_dist(count)] = interp_values_AL(V_app_dist_AL(pos-1),V_app_dist_AL(pos),R_dist_AL(pos-1),R_dist_AL(pos),Ra_dist_final(count));
                    Re_dist(count) = c_dist_final(count)*U_dist(count)*1.2/(1.81*10^-5);  
                end       
    AR = b_dist(count)/c_dist_final(count);
   if Ra_dist_final(count) >= input.radio
    AoA_dist(count) = [];
    Re_dist(count) = [];
    U_dist(count) = [];
    c_dist_final(count) = [];
    b_dist(count) = [];
    Ra_dist_final(count) = [];
    twist_dist_final(count) = [];
       break
    end 
    if AR >= 3 
    count = count + 1;
    airfoil_dist_final = [airfoil_dist_final airfoil_dist_pos];
    radial_positions_inn = radial_positions(i+1);
    end
    if AR<3 && i == (input.n-1)
    airfoil_dist_final = [airfoil_dist_final airfoil_dist_pos];    
    end
end 
end

