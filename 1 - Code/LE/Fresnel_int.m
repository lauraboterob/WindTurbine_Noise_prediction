% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Fresnel integral (Abramowitz & Stegun)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function E = Fresnel_int(x)

% This function computes the Fresnel integral based on the error function
% definition given by Eq. 7.3.22 (Abramowits & Stegun). To compute the
% error function for real and complex numbers, the code developed by
% Kenneth Johnson is used (https://nl.mathworks.com/matlabcentral/
% fileexchange/33577-complex-erf-error-function-fresnel-integrals)
%
% The definition given by Eq. 7.3.22 is based in the definition of a
% Fresnel integral in the format: integral_0^z ( exp(pi*t^2/2) dt) (Eqs.
% 7.3.1 and 7.3.2). However, the Fresnel integral definition used during
% the derivation of the aeroacoustic transfer function is: 
% integral_0_z ( exp(t)/sqrt(2*pi*t) dt) (Eqs. 7.3.3 and 7.3.4 - C_2 and
% S_2). The interrelation of these two definitions is given by Eqs. 7.3.7
% and 7.3.8.

% By applying the interrelation between the two definitions, the Fresnel
% function can be computed by the following equation based on the error
% function.

E = erfz((1-1i)*sqrt(x/2))/(1-1i);

% %MATLAB Fresnel Integral
% E_matlab = fresnelc(x)+1i*fresnels(x);
% 
% figure()
% plot(E)
% hold on
% plot(E_matlab)
% legend('Error function','E_matlab')
end