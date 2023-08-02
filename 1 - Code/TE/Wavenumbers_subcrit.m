function [k_min_bar_prime,A1_prime,A_prime,Theta_prime] = Wavenumbers_subcrit(inputs,mu_bar,K_1_bar,K_2_bar,K_bar,beta)
k_min_bar_prime = sqrt((K_2_bar/beta)^2-mu_bar^2);
A1_prime = K_1_bar + inputs.M*mu_bar - 1i*k_min_bar_prime;
A_prime = K_bar + inputs.M*mu_bar - 1i*k_min_bar_prime;
Theta_prime = sqrt(A1_prime/A_prime);
end

