function [Phi_0] = Phi_0_img_new(sqrt_ix)
x = sqrt_ix.^2*(-1i);
Phi_0 = (1+1*i)*Fresnel_int_conj(x);
end

