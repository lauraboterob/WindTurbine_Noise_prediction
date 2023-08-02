function [C,K_bar,mu_bar,S0,K_1_bar,alpha,U_c,K_2_bar,beta] = wavesnumbers(inputs,fluid,omega)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

kappa   = omega/fluid.c0; %acoustic wavenumber
beta    = sqrt(1-inputs.M^2);
K       = omega/inputs.U; % aerodynamic wavenumber
S0      = sqrt(inputs.x^2 + beta^2*(inputs.y^2+inputs.z^2));

%% Normalization by semichord
b       = inputs.semichord;
X       = inputs.x/b;
Y       = inputs.y/b;
Z       = inputs.z*beta/b;
K_bar   = K*b; 
kappa_bar = kappa*b;

%% Additional parametes to the transfer function
mu_bar  = K_bar*inputs.M/beta^2;
U_c     = 0.7*inputs.U; %convection velocity. MR did not give an specific value
alpha   = inputs.U/U_c;
K_1_bar = alpha*K_bar;
K_2_bar = kappa_bar*inputs.y/S0; %in the case we have not define ky.
C       = K_1_bar-mu_bar*(inputs.x/S0 - inputs.M); %temporal variables 
end

