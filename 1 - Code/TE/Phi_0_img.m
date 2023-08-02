function [phi_0] = Phi_0_img(x)
phi_0 = sqrt(2)*exp(1i*pi/4)*Fresnel_int_conj(x); 
end

