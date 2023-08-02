function [Phi_pp] = phi_pp_Amiet(omega,inputs,fluid)
%This function calculates the surface pressure spectrum with the simplest 
%model that is the model presented in the paper of Amiet. 
delta_s = 0.047*inputs.chord*inputs.Re^(-1/5);
omega_bar = omega*delta_s/inputs.U;
Phi_pp = (1/2*fluid.rho*inputs.U).^2*(delta_s/inputs.U)*2*10^-5./(1+omega_bar...
    +0.217*omega_bar.^2+0.00562*omega_bar.^4);
end

