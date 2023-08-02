%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script to calculate the leading edge noise based on
% the theory of Amiets theory. 
% In this code the transfer functions are calculated from Leandro de
% santana's  thesis
% l.boterobolivar@utwente.nl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
%hold all
%% inputs
[fluid,inputs] = inputs_definition();

%% Define waves number
[f,omega,Kapa,mu,kc,kb,Kyb,Kxb,Ky,Kx,sigma,beta,k] = wavesnumbers(inputs,fluid);

%% Turbulence spectrum
[Phi_ww] = Turbulence_spectrum(Kx,Ky,inputs);

%% Correction spectrum
[Phi_ww] = Turbulence_spectrum_corretion(Phi_ww,inputs,f, fluid,Ky,Kx);

%% Aeroacoustics transfer function
[L,L1,L2] = Transfer_function(mu,beta,inputs,Kx,Ky,sigma,Kapa);

%% far-field noise
[S_pp] = farfield_noise(k,inputs,fluid,sigma,L,Phi_ww);

%% convert to 1/3 octave
[sortedData,Fc,Flow,Fhigh] = NarrowToNthOctave(f,10*log10(S_pp),3);
sortedData_Pa2_db=10*log10(8*pi*10.^(sortedData/10)/(20*10^-6)^2);

%% plots
plots(f,S_pp)



