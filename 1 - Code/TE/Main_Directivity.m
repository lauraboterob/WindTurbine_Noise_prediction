%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script to calculate the trailing edge noise at different
% directivity angles based on the theory of Roger-Moreu 2005. 
% In this code, the back scattering effect is also taken into account. 
% Laura Botero Bolívar - University of Twente 
% l.boterobolivar@utwente.nl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Set the case
clear all
[fluid,input] = inputs_definition();
R = input.z;
angle = 1:2:179;
x = R*cosd(angle);
z = R*sind(angle);
%% specifiy frequency
kc = 1;
k = kc/input.chord;
omega_d = k*fluid.c0;

for i = 1: length(x)
input.x = x(i);
input.z = z(i);
%% Trailing edge noise prediction
[omega, S_pp, I, S0] = TE_noise_Prediction(input,fluid);
%% plot for the specific frequency
[~,pos] = min(abs(omega_d-omega));
S_pp_d(i) = S_pp(pos);
factor(i) = abs(kc*I(pos)).*(input.z/S0);
end 

figure()
polar(angle*pi/180,S_pp_d)


figure()
polar(angle*pi/180,factor)












