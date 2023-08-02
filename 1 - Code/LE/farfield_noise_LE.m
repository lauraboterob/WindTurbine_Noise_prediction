function [S_pp] = farfield_noise_LE(k,inputs,fluid,sigma,L,phi_ww)
b = inputs.semichord;
d = inputs.span/2;
S_pp = (((k*inputs.z*fluid.rho*b)./(sigma^2)).^2).*(pi*inputs.U*d*abs(L).^2.*phi_ww);
end

