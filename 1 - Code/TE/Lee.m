function [a_star,b,c,d,e,f,g,h,i,R,phi_s,omega_s] = Lee(inputs,fluid,c_f, theta, dcpdcx,delta_s,delta,Ue, omega, u_t)
%u_t = 0.0318*56;
dpdx = dcpdcx*(0.5*fluid.rho*inputs.U^2/inputs.chord);
tau_w = 0.5*fluid.rho*inputs.U^2*c_f;
beta_c = (theta/tau_w)*(dpdx);
Delta_star = delta/delta_s;
Pi_w = 0.8*(beta_c+0.5)^(3/4);
e = 3.7+1.5*beta_c;
d = 4.76*(1.4/Delta_star)^0.75*(0.375*e-1); 
if beta_c < 0.5
    d = max([1,1.5*d]);
end
a = (2.82*Delta_star^2*(6.13*Delta_star^-0.75+d)^e)*(4.2*Pi_w/Delta_star+1);
a_star = max([1,(0.25*beta_c-0.52)])*a;
b = 2;
c = 0.75;
f = 8.8;
g = -0.57;
Rt= (delta/(Ue*inputs.U))/(fluid.ni/u_t^2);
h = min([3,0.139+3.1043*beta_c])+7;
% h = min([5.35,0.139+3.1043*beta_c,19/sqrt(Rt)])+7;
% if h == 12.35
%     h = min([3,19/sqrt(Rt)])+7;
% end 
i = 4.76;
R = Rt;
phi_s = tau_w^2*delta_s/(Ue*inputs.U);
omega_s = omega*delta_s/(Ue*inputs.U);
end

