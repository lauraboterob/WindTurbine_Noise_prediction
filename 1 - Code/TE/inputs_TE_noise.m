function [input] = inputs_TE_noise(fluid,y1,y2,y3,U,airfoil,c,beta_angle,AoA,b)
input = struct;
input.perfil   = airfoil;
input.chord    = c;
input.span     = b;
input.semichord = input.chord/2;
input.U        = U;
input.beta      = beta_angle;
input.xtr_s    = 0.2;
input.xtr_p    = 0.2;
input.Mic      = 0.99;
input.x        = y1;
input.y        = y2;
input.z        = y3;
input.M        = U/fluid.c0;
input.Re       = input.chord*input.U/fluid.ni;
input.AoA      = AoA;
end

