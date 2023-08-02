function [L, L1, L2] = Transfer_function_LE(mu,beta,inputs,kx,ky,sigma,Kapa)
b = inputs.semichord;
x = inputs.x;
y = inputs.y;
z = inputs.z;
M = inputs.M;

for i = 1:length(Kapa)
  if   (Kapa(i)^2)>0
        kapa = sqrt(mu.^2 - (ky*b/beta).^2);
        theta1 = kapa - mu*x/sigma;
        theta2 = mu*(M - x/sigma) - pi/4;
        theta3 = kapa + mu*x/sigma;
        
        L1 = (1/pi) * sqrt( 2 ./ (theta1 .* (kx*b + beta^2*kapa))) .* ...
            Fresnel_int_conj(2*theta1) .* exp(1i*theta2);

        L2 = exp(1i*theta2) ./ (theta1.*pi.*sqrt(2*pi*(kx*b+beta^2.*kapa))).* ...
            ( 1i*(1-exp(-1i*2*theta1)) + (1-1i)*(Fresnel_int_conj(4*kapa) - ...
            sqrt(2*kapa./theta3).* exp(-1i*2*theta1).* Fresnel_int_conj(2*theta3)));

        L=L1+L2;
  else 
        kapa_p = sqrt( ((k_y*b).^2)/(beta^2) - mu^2 );
        theta = -(mu*x/sigma + 1i*kapa_p);

        L1 = 1 ./ (pi*sqrt(kapa_p*beta^2+1i*k_x*b)) .* (exp(1i*mu*(M-x/sigma))).* ...
            1/sqrt(theta) .* exp(-1i*pi/4) .* erfz(2*1i*theta);

        L2 = -exp(1i*mu*(M-x/sigma)) ./ (pi*sqrt(2*pi*(kapa_p*beta^2+1i*k_x*b))).* ...
            1./(kapa_p-1i*mu*x/sigma) .* ( 1 - erfz(sqrt(4*kapa_p)) - ...
            exp(-2*(kapa_p-1i*mu*x/sigma)) + sqrt(2*kapa_p) .* exp(-2*(kapa_p-1i*mu*x/sigma))./sqrt(kapa_p+1i*mu*x/sigma).* ...
            erfz(sqrt(2*(kapa_p+1i*mu*x/sigma))) );
        
        L=L1+L2;     
  end  
end 
end

