function [U,dUdy] = mean_velocity_profile(y,delta,u_t,fluid,inputs, dcpdxc,tau_w,delta_s)
k = 0.38;
B = 5;
y_plus = y*u_t/fluid.ni;
dcpdx = dcpdxc*(1/inputs.chord);
beta = delta_s/tau_w*dcpdx;
Pi_w = 0.8*(beta+0.5)^(3/4);

%% for the inner layer
u_plus(y_plus<5) = y_plus(y_plus<5);

%% for the outer layer
u_plus(y_plus>5) = (1/k)*log(y_plus(y_plus>5))+B+(2*Pi_w/k)*sin(pi*y(y_plus>5)/(2*delta)).^2;
u_plus = u_plus';
%% Streamwise velocity
U = u_plus*u_t;

%% derivative
dUdy = diff(U)./diff(y);
dUdy(end+1) = (U(end)-U(end-1))/(y(end)-y(end-1));
end

