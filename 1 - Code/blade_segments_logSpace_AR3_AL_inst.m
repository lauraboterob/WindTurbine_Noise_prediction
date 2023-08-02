function [blade] = blade_segments_logSpace_AR3_AL_inst(input,blade)
airfoil_dist_final = [];
R_dist =blade.R_dist;
c_dist =blade.c_dist;
thickness_dist =blade.thickness_dist;
twist_dist = blade.twist_dist;
airfoil_dist =blade.airfoil_dist;
%% Stablish radial positions
theta = linspace(0,90,input.n+2);
delta = (input.radio-input.innitial_ratio )*cosd(theta); %(input.radio - input.innitial_ratio)/input.n; % % logspace(0,log10(input.radio-9),input.n+1); % 9 is the fisrt position with no cylinder
radial_positions = input.innitial_ratio  + flip(delta(1:end)); %input.innitial_ratio:delta:(input.radio-delta);%9:delta:(input.radio-delta);  
count = 1;
radial_positions_inn = radial_positions(count);
for i = 1:(input.n-1)
    b_dist(count) = radial_positions(i+1) - radial_positions_inn;
    Ra_dist_final(count)  =radial_positions_inn + b_dist(count)/2;
    pos_r = find(diff(sign(Ra_dist_final(count) - R_dist)))+1;
                if pos_r == 2
               % interpolate the geomtrical parameters at Ra
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
                % interpolate the geomtrical parameters at Ra
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
    AR = b_dist(count)/c_dist_final(count);
   if Ra_dist_final(count) >= input.radio
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
blade.airfoil_dist_final = airfoil_dist_final;
blade.twist_dist_final = twist_dist_final;
blade.Ra_dist_final = Ra_dist_final;
blade.c_dist_final = c_dist_final;
blade.b_dist = b_dist;
end

