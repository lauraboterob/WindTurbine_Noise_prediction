function [u_x,u_y] = velocity_fluctuations(U, inputs)
gamma =64;
Q = 1-exp(-gamma*(1-U/inputs.U));
a = 0.2909;
b = -0.2598;
u_x = U.*((a+b*U/inputs.U).*Q);
u_y = 0.5*u_x;
end

