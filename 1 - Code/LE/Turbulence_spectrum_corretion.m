function [Phi_ww_cor] = Turbulence_spectrum_corretion(Phi_ww,inputs,f,fluid,Ky,Kx)
nu = fluid.ni;
k = sqrt(Kx.^2+Ky.^2);
TF = strcmp(inputs.correction,'No-Correction');
if TF == 1 
   Phi_ww_cor = Phi_ww;
end    
f_k = 163.1*inputs.U^1.12*inputs.urms^0.4;
TF = strcmp(inputs.correction,'Roger-Moreau');
if TF == 1 
     Phi_ww_cor = Phi_ww.*exp(-(9/4)*(f/f_k).^(2));
end    
TF = strcmp(inputs.correction,'Dissipation-range');
if TF == 1 
    LS_taylor = inputs.U/f_k;
    epsilon = 15*nu*inputs.urms^2/((2*LS_taylor)^2);
    eta = ((nu^3)/epsilon)^(1/4);
    Phi_ww_cor = Phi_ww.*exp(-4.6*(eta*k).^1.5);
end   
end

