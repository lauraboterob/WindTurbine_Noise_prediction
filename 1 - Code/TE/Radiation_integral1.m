function [f1] = Radiation_integral1(B,C)
%This is the transfer function that account for the propagation of TE
%noise. This transfer function is idental to that for Amiet. 
f1 = (-exp(2i*C)/(1i*C))*((1+1i)*exp(-2i*C)*sqrt(2*B)*(Fresnel_int_conj(2*(B-C))/...
sqrt(2*(B-C)))-(1+1i)*Fresnel_int_conj(2*B)+1);%-exp(-2i*C));
%f1 = (-exp(2i*C)/(1i*C))*((1+1i)*exp(-2i*C)*sqrt(2*B)*(ES_conj(2*(B-C)))...
%    -(1+1i)*Fresnel_int_conj(2*B)+1); %-exp(-2i*C));
%a = Fresnel_int_conj(2*(B-C));
%b = Fresnel_int_conj(2*B);
 %(-np.exp(2*1j*C)/(1j*C)) *
 %((1+1j)*np.exp(-2*1j*C)*np.sqrt(2*B)*ES_star(2*(B-C))-(1+1j)*E_star(2*B)+1)
 %Andrea's formula
end

