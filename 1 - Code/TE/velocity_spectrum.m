function [phi_uu,phi_vv,Uc,kx] = velocity_spectrum(gamma_x_uu, omega, inputs)
beta_x = 1;
beta_y = 1/2;
beta_z = 3/4;
Uc = 0.6*inputs.U;
kx = omega/Uc;
ke = (sqrt(pi)./gamma_x_uu).*(gamma(5/6)/gamma(1/3));
phi_uu = (gamma(5/6)/(sqrt(pi)*gamma(1/3)))*(beta_x./ke).*(1./(1+(beta_x*kx./ke).^2).^(5/6));
phi_vv = (4/(9*pi))*(beta_x*beta_z./ke.^2).*((beta_x*kx./ke).^2./(1+(beta_x*kx./ke).^2).^(7/3));
end

