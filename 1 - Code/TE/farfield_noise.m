function [S_pp_s,S_pp_p] = farfield_noise(inputs,fluid,omega,S0,I,Pi0_s,Pi0_p)
% far-field noise calculated in the position x,y,z from the input. 
S_pp_s = (1/4)*(omega*inputs.z*inputs.chord/2./(2*pi*fluid.c0*S0^2)).^2*2*pi*inputs.span...
    .*abs(I).^2.*Pi0_s;
S_pp_p = (1/4)*(omega*inputs.z*inputs.chord/2./(2*pi*fluid.c0*S0^2)).^2*2*pi*inputs.span...
    .*abs(I).^2.*Pi0_p;
end

