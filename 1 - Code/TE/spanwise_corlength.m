function [l_y] = spanwise_corlength(U_c,omega,K_2_bar,inputs)
%This function calculates the spanwise correlation length for a  turbulent
%boundary layer
b = inputs.chord/2;
b_c = 1.47; %corcos' constant. 
K_2 = K_2_bar/b;
l_y = (omega./(b_c*U_c))./(0 +  omega.^2./(b_c*U_c)^2);
end

