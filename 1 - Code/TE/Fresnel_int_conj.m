% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Complex Conjugate of the Fresnel integral
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E_s = Fresnel_int_conj(x)
%E_s = conj(Fresnel_int(x));
temp = -(1-erfz((1+1i)*sqrt(0.5*x))); %RM page 8
E_s = (temp + 1)/(1+1i);
end