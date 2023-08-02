function [Kapa,mu,kc,kb,Kyb,Kxb,Ky,Kx,sigma,beta,k] = wavesnumbers_LE(inputs,fluid,omega)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% geometrical parameters
b = inputs.semichord;
c = inputs.chord;

%% frequenct definition
k   = omega/fluid.c0; %acoustic wavenumber
beta    = sqrt(1-inputs.M^2);
sigma     = sqrt(inputs.x^2 + beta^2*(inputs.y^2+inputs.z^2));

Kx      = omega/inputs.U;              % Chordwise wavenumber [rad/m]
Ky      = k*inputs.y/sigma;        % Spanwise wavenumber [rad/m]
Kxb     = Kx*b;
Kyb     = Ky*b;
kb      = sqrt(Kxb.^2+Kyb.^2);             
kc      = k*c;

mu      = Kxb*inputs.M/beta^2;                     % mu
Kapa       = sqrt(mu.^2-(Kyb./beta).^2);    % Kapa
end

