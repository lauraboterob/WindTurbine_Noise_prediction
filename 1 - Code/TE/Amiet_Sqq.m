function [S_qq] = Amiet_Sqq(input, fluid, omega, delta_s)
omega_s = omega*delta_s/input.U;
S_qq = (0.5*fluid.rho*input.U^2)^2*(delta_s/input.U)*2*10^-5./(1+omega_s+0.217*omega_s.^2+0.005624*omega_s.^4);
end

