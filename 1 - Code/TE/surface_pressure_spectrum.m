function [Phi_pp_s,Phi_pp_p] = surface_pressure_spectrum(omega,inputs,fluid,model,delta_s,tau_w_s,u_t_s,delta_p,tau_w_p,u_t_p,Ue_s,Ue_p,dcpdx_s,dcpdx_p,delta_s_s,delta_s_p,cf_s,cf_p,theta_s,theta_p)
%% Several wall pressure models 
tf = strcmp(model,'Goody');
if tf == 1   
    [a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s] = Goody(omega,tau_w_s,delta_s,Ue_s,u_t_s,fluid,inputs);
    [Phi_pp_s] = phi_pp_oneside(a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s);
    [a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_s] = Goody(omega,tau_w_p,delta_p,Ue_p,u_t_p,fluid,inputs);
    [Phi_pp_p] = phi_pp_oneside(a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_s);
end
tf = strcmp(model,'Kamruzzaman');
if tf ==1
    [a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s] = Kamruzzaman(inputs,fluid,cf_s, theta_s, dcpdx_s,delta_s_s,Ue_s, omega,u_t_s);
    [Phi_pp_s] = phi_pp_oneside(a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s);
    [a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_p] = Kamruzzaman(inputs,fluid,cf_p, theta_p, dcpdx_p,delta_s_p,Ue_p, omega,u_t_s);
    [Phi_pp_p] = phi_pp_oneside(a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_p);    
end 
tf = strcmp(model,'TNO');
if tf ==1
    [Phi_pp_s] = 2*TNO(delta_s,u_t_s,fluid,inputs, dcpdx_s,tau_w_s,delta_s_s,omega);
    [Phi_pp_p] = 2*TNO(delta_p,u_t_p,fluid,inputs, dcpdx_p,tau_w_p,delta_s_p,omega);
end
tf = strcmp(model,'Amiet');
if tf == 1
    [Phi_pp_s] = Amiet_Sqq(inputs, fluid, omega, delta_s_s);
    [Phi_pp_p] = Amiet_Sqq(inputs, fluid, omega, delta_s_p);
end
tf = strcmp(model,'Lee');
if tf == 1
    [a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s] = Lee(inputs,fluid,cf_s, theta_s, dcpdx_s,delta_s_s,delta_s,Ue_s, omega, u_t_s);
    [Phi_pp_s] = phi_pp_oneside(a_s,b_s,c_s,d_s,e_s,f_s,g_s,h_s,i_s,R_s,phi_s_s,omega_s);
    [a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_p] = Lee(inputs,fluid,cf_p, theta_p, dcpdx_p,delta_s_p,delta_p,Ue_p, omega, u_t_p);
    [Phi_pp_p] = phi_pp_oneside(a_p,b_p,c_p,d_p,e_p,f_p,g_p,h_p,i_p,R_p,phi_s_p,omega_p); 
end
end

