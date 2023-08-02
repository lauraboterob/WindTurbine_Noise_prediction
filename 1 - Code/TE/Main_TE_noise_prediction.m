%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script to calculate the trailing edge noise based on
% the theory of Roger-Moreu 2005. 
% In this code, the back scattering effect is also taken into account. 
% Laura Botero Bolívar - University of Twente 
% l.boterobolivar@utwente.nl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all

%% inputs
[fluid,inputs] = inputs_definition();

%% Define waves number
[f,omega,C,K_bar,mu_bar,S0,K_1_bar,alpha,U_c,K_2_bar,beta] = wavesnumbers(inputs,fluid);

%% Transfer functions for subcritical and supercritical ghusts
[I] = Radiation_integral_total(C,K_bar,mu_bar,S0,K_1_bar,K_2_bar,alpha,inputs,beta);

%% Spanwise correlation length 
[l_y] = spanwise_corlength(U_c,omega,K_2_bar,inputs);

%% Wall pressure PSD
[Phi_pp_s,Phi_pp_p] = surface_pressure_spectrum(omega,inputs,fluid,inputs.model);

%% Stream-wise integrated wavenumber spectral density of wall-pressure fluctuations
[Pi0_s,Pi0_p] = Integrated_WPS(l_y,Phi_pp_s,Phi_pp_p);

%% far-field noise
[S_pp_s,S_pp_p] = farfield_noise(inputs,fluid,omega,S0,I,Pi0_s,Pi0_p);
S_pp = S_pp_s + S_pp_p;

%% convert to 1/3 octave
[sortedData,Fc,Flow,Fhigh] = NarrowToNthOctave(f,10*log10(S_pp_s),3);
sortedData_Pa2_db=10*log10(8*pi*10.^(sortedData/10)/(20*10^-6)^2);

%% plots
plots(f,I,Phi_pp_s,Phi_pp_p,S_pp,S_pp_s,S_pp_p)




