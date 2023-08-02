function [delta,tau_w,u_t,Rt] = Boundary_layer_characteristics(delta_s,theta,c_f,U,fluid)
% this function calculates the boundary layer characteristics based on the
% outputs of xfoil
delta = (theta*(3.15+1.75/(delta_s/theta-1))+delta_s);
tau_w = c_f*1/2*fluid.rho*U^2;
u_t   = sqrt(tau_w/fluid.rho);
end

