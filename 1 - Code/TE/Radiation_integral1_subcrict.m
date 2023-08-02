function [f1_prime] = Radiation_integral1_subcrict(C,A1_prime,mu_bar,inputs,S0,k_min_bar_prime)
temp1 = 2*(mu_bar*(inputs.x/S0)-1i*k_min_bar_prime);
temp2 = 2*A1_prime;
%f1_prime = -(exp(2*1i*C)/(1i*C))*(exp(-2*1i*C)*sqrt(temp2)*(1+1i)*...
%    ES_conj(temp1)- Phi_0_img(temp2)+1);
f1_prime = (-exp(2*1i*C)/(1i*C))*(exp(-2*1i*C)*sqrt(temp2)*(1+1i)*...
    Fresnel_int_conj(temp1)/sqrt(temp1)- Phi_0_img_new(sqrt(2*A1_prime*1i))+1);

 %(-np.exp(2*1j*C)/(1j*C))*(np.exp(-2*1j*C)*np.sqrt(2*A1p)*(1+1j)
 %*ES_star(2*((mu*self.X[0]/self.sigma0) - 1j*kappa))-phi0((2*1j*A1p)**0.5)+1)
end

