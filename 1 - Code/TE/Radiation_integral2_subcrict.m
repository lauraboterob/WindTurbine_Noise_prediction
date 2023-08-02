function [f2_prime] = Radiation_integral2_subcrict(A_prime,A1_prime,mu_bar,inputs,S0,k_min_bar_prime,alpha,K_bar,Theta_prime)
D_prime = mu_bar*inputs.x/S0 - 1i*k_min_bar_prime;
H_prime = ((1+1i)*(1-Theta_prime^2))/(2*sqrt(pi)*(alpha-1)*K_bar*sqrt(A1_prime));
temp3 = -2*conj(D_prime);
f2_prime = (exp(-2*1i*D_prime)/D_prime)*H_prime*(A_prime*(exp(2*1i*D_prime)....
    *(1-erf(sqrt(4*k_min_bar_prime)))-1)+(2*sqrt(2*k_min_bar_prime)*...
    (K_bar+(inputs.M-inputs.x/S0)*mu_bar)*ES_conj(temp3)));
end

