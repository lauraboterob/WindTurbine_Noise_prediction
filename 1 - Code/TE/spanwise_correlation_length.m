function [gamma_p_z] = spanwise_correlation_length(omega, Uc)
bc = 1.4;
gamma_p_z = bc*Uc./omega;
end

