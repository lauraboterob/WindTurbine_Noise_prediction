function [omega,omega_e,U,wswr,Mbc0Te] = retarded_frequency(inputs,fluid,Psi,f,Ra)
omega = 2*pi*f;
rot_speed = inputs.rpm*(2*pi/60);
U = sqrt((rot_speed*Ra)^2+inputs.U^2);
M_t = rot_speed*Ra/fluid.c0;
% omega_e = omega*(1 + M_t*sind(90-Psi)*sind(inputs.Theta)); %% optional
% way to calculate omega_e accoring to Rozenberg 2007.
xr = [inputs.R0x inputs.R0y inputs.R0z];
xe = Ra*[-sind(Psi) cosd(Psi) 0];
R = norm(xr - xe);
Rz = dot((xr - xe),[0 0 1]);
Mf = [0 0 inputs.U/fluid.c0];
Mb  = M_t*[-cosd(Psi) -sind(Psi) 0];
c0Te = (-norm(Mf)*Rz + sqrt(norm(Mf)^2*Rz^2 + (1-norm(Mf)^2)*R^2))/(1-norm(Mf)^2);
xc = xe + Mf*c0Te;
Mbc0Te = Mb*c0Te;
CR = (xr-xc)/norm(xr-xc);
wswr = (1+dot((Mf-Mb),CR))/(1+dot(Mf,CR)); 
omega_e = omega*wswr;
end

