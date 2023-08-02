function [Pi0_s,Pi0_p] = Integrated_WPS(l_y,Phi_pp_s,Phi_pp_p)
%This function calculates the streamwise wavenumber integrated spectrum
%of the wall pressure fluctuations
Pi0_s = 1/pi*Phi_pp_s.*l_y;
Pi0_p = 1/pi*Phi_pp_p.*l_y;
end

