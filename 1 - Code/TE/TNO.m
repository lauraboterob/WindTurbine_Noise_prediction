function [phi_pp] = TNO(delta,u_t,fluid,inputs, dcpdxc,tau_w,delta_s,omega)
delta = delta*1.2;
y = linspace(0.0001, delta, 250)';

%% mean velocity profile 
[U,dUdy] = mean_velocity_profile(y,delta,u_t,fluid,inputs, dcpdxc,tau_w,delta_s);

%% Velocity fluctuations
[u_x, u_y] = velocity_fluctuations(U, inputs);

%% Integral length scale 
[gamma_y_vv, gamma_x_uu] = Integral_Length_scale(delta, y);

%% Velocity spectrum
[phi_uu,phi_vv,Uc,kx] = velocity_spectrum(gamma_x_uu, omega, inputs);
 
%% spanwise correlation length
[gamma_p_z] = spanwise_correlation_length(omega, Uc);

%% integration of Pi_w
[phi_pp] = Point_spectrum(U,dUdy, u_y,gamma_y_vv,phi_vv,gamma_p_z,Uc,omega,y,inputs,kx, fluid);
end

