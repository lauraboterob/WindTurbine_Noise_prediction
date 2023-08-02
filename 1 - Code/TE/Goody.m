function [a,b,c,d,e,f,g,h,i,R,phi_s,omega_s] = Goody(omega,tau_w,delta,Ue,u_t,fluid,inputs)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
a = 3;
b = 2;
c = 0.75;
d = 0.5;
e = 3.7;
f = 1.1;
g = -0.57;
h = 7;
i = 1;
Ue = Ue*inputs.U; %inputs.U;
Rt= (delta/Ue)/(fluid.ni/(u_t)^2);
R = Rt;
phi_s   = tau_w^2*delta/Ue;
omega_s = omega*delta/Ue;
end

