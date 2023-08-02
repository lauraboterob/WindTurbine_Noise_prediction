function [S_pp_LE] = LE_noise_Prediction(omega_e,fluid,U,airfoil,b,c,y1,y2,y3,u_rms,LE)
%% inputs
omega = omega_e;
f = omega/(2*pi);
[inputs] = inputs_definition_LE(fluid,U,airfoil,b,c,y1,y2,y3,u_rms,LE);

%% Define waves number
 [Kapa,mu,~,~,~,~,Ky,Kx,sigma,beta,k] = wavesnumbers_LE(inputs,fluid,omega);

%% Turbulence spectrum
[Phi_ww] = Turbulence_spectrum(Kx,Ky,inputs);

%% Correction spectrum
[Phi_ww] = Turbulence_spectrum_corretion(Phi_ww,inputs,f, fluid,Ky,Kx);

%% Aeroacoustics transfer function
[L,~,~] = Transfer_function_LE(mu,beta,inputs,Kx,Ky,sigma,Kapa);

%% far-field noise
[S_pp_LE] = farfield_noise_LE(k,inputs,fluid,sigma,L,Phi_ww);
end

