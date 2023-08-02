function [Pi_w] = Point_spectrum(U,dUdy, u_y,gamma_y_vv,phi_vv,gamma_p_z,Uc,omega,y,inputs,kx, fluid)
Uc_y = Uc/inputs.U.*U;
for i = 1:length(omega)
temp = gamma_y_vv.*Uc_y.*dUdy.^2.*(u_y.^2)./(Uc_y.^2).*phi_vv(:,i).*exp(-2*abs(kx(i)).*y);
Pi_w(i) =   (4*pi*fluid.rho^2./gamma_p_z(i)).*trapz(y,temp);  
end 
end

