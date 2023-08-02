function [psi_inn_blade1,psi_inn_blade2,psi_inn_blade3,ts_final,conv,rot_speed] = calculate_ts(inputs)
rot_speed = inputs.rpm*(2*pi/60);
psi_inn_blade1 = mod(rot_speed*inputs.t0,2*pi);
psi_finn = psi_inn_blade1 + 2*pi;
t_rev = 2*pi/rot_speed;
conv = (inputs.delta_ts/inputs.dt);
ts_final = (t_rev)*conv + inputs.ts_in;
psi_inn_blade2 = psi_inn_blade1 + 2*pi/3;
psi_inn_blade3 = psi_inn_blade1 + 4*pi/3;
end

