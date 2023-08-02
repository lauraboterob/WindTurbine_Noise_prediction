function [S_pp_TE,S0,K_2_bar,I,Pi0_s] = TE_noise_Prediction(fluid,omega_e,y1,y2,y3,U,airfoil,c,beta_angle,AoA,b,delta_s,tau_w_s,u_t_s,delta_p,tau_w_p,u_t_p,Ue_s,Ue_p,dcpdx_s,dcpdx_p,delta_s_s,delta_s_p,cf_s,cf_p,theta_s,theta_p)
omega = omega_e;
[inputs] = inputs_TE_noise(fluid,y1,y2,y3,U,airfoil,c,beta_angle,AoA,b);
%% Define waves number
[C,K_bar,mu_bar,S0,K_1_bar,alpha,U_c,K_2_bar,beta] = wavesnumbers(inputs,fluid,omega);
%% Transfer functions for subcritical and supercritical ghusts
[I] = Radiation_integral_total(C,K_bar,mu_bar,S0,K_1_bar,K_2_bar,alpha,inputs,beta);
%% Spanwise correlation length 
[l_y] = spanwise_corlength(U_c,omega,K_2_bar,inputs);
%% Stream-wise integrated wavenumber spectral density of wall-pressure fluctuations
model = 'TNO' ; %change for 'Goody''Kamruzzaman' 'Amiet' or 'Lee'
[Phi_pp_s,Phi_pp_p] = surface_pressure_spectrum(omega,inputs,fluid,model,delta_s,tau_w_s,u_t_s,delta_p,tau_w_p,u_t_p,Ue_s,Ue_p,dcpdx_s,dcpdx_p,delta_s_s,delta_s_p,cf_s,cf_p,theta_s,theta_p);
% model = 'Goody' ;
%[~,Phi_pp_p] = surface_pressure_spectrum(omega,inputs,fluid,'Goody',delta_s,tau_w_s,u_t_s,delta_p,tau_w_p,u_t_p,Ue_s,Ue_p,dcpdx_s,dcpdx_p,delta_s_s,delta_s_p,cf_s,cf_p,theta_s,theta_p);
[Pi0_s,Pi0_p] = Integrated_WPS(l_y,Phi_pp_s,Phi_pp_p);
%% far-field noise
[S_pp_s,S_pp_p] = farfield_noise(inputs,fluid,omega,S0,I,Pi0_s,Pi0_p);
S_pp_TE = S_pp_s + S_pp_p;
end

