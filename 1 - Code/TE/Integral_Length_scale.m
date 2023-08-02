function [gamma_y_vv, gamma_x_uu] = Integral_Length_scale(delta, y)
k = 0.38;
l_mix = 0.085*delta*tanh(k/0.085*y/delta);
gamma_y_vv = l_mix/k;
gamma_x_uu =2*gamma_y_vv; %isotropic turbulence. 
end

