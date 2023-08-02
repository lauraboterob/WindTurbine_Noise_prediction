function [Phi_pp] = phi_pp_oneside(a,b,c,d,e,f,g,h,i,R,phi_s,omega_s)
Phi_pp  = phi_s*((a*omega_s.^b)./((i*omega_s.^c+d).^e+(f.*R^g*omega_s).^h));
end

