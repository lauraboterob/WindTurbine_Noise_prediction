function [a,b,c,d,e,f,g,h,i,R,phi_s,omega_s] = Kamruzzaman(inputs,fluid,c_f, theta, dcpdcx,delta_s,Ue, omega, u_t)
dpdx = dcpdcx*(0.5*fluid.rho*inputs.U^2/inputs.chord);
tau_w = 0.5*fluid.rho*inputs.U^2*c_f;
beta_c = (theta/tau_w)*(dpdx);
lambda = sqrt(2/c_f);
G = 6.1*sqrt(beta_c+1.81)-1.7;
H = 1-G/lambda;
%H = 1.676;
Pi = 0.8*(beta_c+0.5)^(3/4);
m = 0.5*(H/1.31)^0.3;
a = 0.45*(1.75*(Pi^2*beta_c^2)^m +15);
b = 2;
c = 1.637;
d = 0.27;
e = 2.47;
f = 1.15^(-2/7);
g = -2/7;
h = 7;
i = 1;
R = (delta_s*u_t^2)/(fluid.ni*Ue*inputs.U);
phi_s = tau_w^2*delta_s/(Ue*inputs.U);
omega_s = omega*delta_s/(Ue*inputs.U);
end

