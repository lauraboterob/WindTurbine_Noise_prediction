function [f2] = Raditation_integral2(B,K_bar,k_min_bar,mu_bar,S0,K_1_bar,alpha,inputs)
%   This function calculates the radiation integral that accounts for the
%   back-scattering effect from the LE. 

error = (1+1/(4*mu_bar))^(-1/2); % Eq. 9 
D = k_min_bar - mu_bar*inputs.x/S0; 
E = exp(4i*k_min_bar)*(1-(1+1i)*Fresnel_int_conj(4*k_min_bar));
E_final = real(E)+1i*error*imag(E);
G_a = (1+error)*exp(1i*(2*k_min_bar+D))*sin(D-2*k_min_bar)/(D-2*k_min_bar);
G_b = (1-error)*exp(1i*(-2*k_min_bar+D))*sin(D+2*k_min_bar)/(D+2*k_min_bar);
G_c = (1+error)*((1-1i)/(2*(D-2*k_min_bar)))*exp(4i*k_min_bar)...
    *Fresnel_int_conj(4*k_min_bar);
G_d = (1-error)*((1+1i)/(2*(D+2*k_min_bar)))*exp(-4i*k_min_bar)...
    *Fresnel_int(4*k_min_bar);
G_e = exp(2i*D)/sqrt(2)*sqrt(2*k_min_bar)*Fresnel_int_conj(2*D)/sqrt(2*D)...
    *((1+1i)*((1-error)/(D+2*k_min_bar))...
      -(1-1i)*((1+error)/(D-2*k_min_bar)));
G = G_a + G_b + G_c - G_d + G_e;
A = K_bar+(1+inputs.M)*mu_bar;
A_1 = K_1_bar+(1+inputs.M)*mu_bar;
Theta = sqrt(A_1/A);
H = ((1+1i)*exp(-4i*k_min_bar)*(1-Theta^2))/(2*sqrt(pi)*(alpha-1)*K_bar.*sqrt(B));
f2 = H*(E_final-exp(2i*D)+1i*(D+K_bar+inputs.M*mu_bar-k_min_bar)*G);
end

