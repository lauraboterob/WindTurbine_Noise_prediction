function [S_pp_blade] = Far_field_noise_blade(Psi,AL_file,inputs,blade,f,fluid)

%% take the data 
airfoil_dist = blade.airfoil_dist_final;
twist_dist = blade.twist_dist_final;
Ra_dist = blade.Ra_dist_final;
c_dist = blade.c_dist_final;
b_dist = blade.b_dist;
%% take AL data
[AoA_dist,U_dist,Re_dist] = find_AL_data_distr(blade,AL_file);

%% calculate noise
for i = 1:length(c_dist)
    c = c_dist(i);
    twist = twist_dist(i);
    airfoil = airfoil_dist(i);
    AoA = AoA_dist(i);
    b = b_dist(i);
    Ra = Ra_dist(i);
    [omega,omega_e,~,~,Mbc0Te] = retarded_frequency(inputs,fluid,Psi,f,Ra);
    U = U_dist(i);
    [y1, y2, y3] = Coordinates_definition(inputs,twist,AoA,Ra,Psi,Mbc0Te);
    Re = Re_dist(i);
    M = U/fluid.c0;
    [delta_s_s(i),delta_s_p(i),theta_s(i),theta_p(i),cf_s(i),cf_p(i),~,~,Ue_s(i),Ue_p(i),dcpdx_s(i),dcpdx_p(i)] = XFOIL_new_airfoil(airfoil,AoA,Re,M,0.065,0.065,c,0.97);
    %boundary layer parameter for each side of the airfoil
    [delta_s(i),tau_w_s(i),u_t_s(i)] = Boundary_layer_characteristics(delta_s_s(i),theta_s(i),cf_s(i),U,fluid);
    [delta_p(i),tau_w_p(i),u_t_p(i)] = Boundary_layer_characteristics(delta_s_p(i),theta_p(i),cf_p(i),U,fluid);
    [S_pp_TE(i,:)]  = TE_noise_Prediction(fluid,omega_e,y1,y2,y3,U,airfoil,c,twist,AoA,b,delta_s(i),tau_w_s(i),u_t_s(i),delta_p(i),tau_w_p(i),u_t_p(i),Ue_s(i),Ue_p(i),dcpdx_s(i),dcpdx_p(i),delta_s_s(i),delta_s_p(i),cf_s(i),cf_p(i),theta_s(i),theta_p(i));
    %[S_pp_TE(i,:),S0(i,k),K_2_bar(i,k,:),I(i,k,:),Pi0_s(i,k,:),temp(i,k,:)]  = TE_noise_Prediction(fluid,omega_e(:,k)',y1(k,i),y2(k,i),y3(k,i),U,airfoil,c,twist,AoA,b); 
   if inputs.LE == 1
    [S_pp_LE(i,:)] = LE_noise_Prediction(omega_e,fluid,U,airfoil,b,c,y1,y2,y3,inputs.u_rms,inputs.L);
    S_pp_total(i,:) = (S_pp_TE(i,:)+ S_pp_LE(i,:)).*(omega_e./omega).^2;   
   else 
    S_pp_total(i,:) = (S_pp_TE(i,:)).*(omega_e./omega).^2;   
   end 
end 
    S_pp_blade = sum(S_pp_total(:,:),1);
end

