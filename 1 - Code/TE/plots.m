function [] = plots(f,I,Phi_pp_s,Phi_pp_p,S_pp,S_pp_s,S_pp_p)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
fh = 1;
% figure(fh)
% semilogx(f,abs(I).^2)
% hold on
% xlabel('f')
% ylabel('Radiation Integral')
% fh = fh + 1;

figure(fh)
semilogx(f,10*log10(2*pi*Phi_pp_p/(20*10^-6)^2))
hold on
semilogx(f,10*log10(2*pi*Phi_pp_s/(20*10^-6)^2))
xlabel('f')
ylabel('phi_pp')
legend('pressure','suction')
fh = fh + 1;

figure(fh)
semilogx(f,10*log10(8*pi*S_pp/(20*10^-6)^2))
hold on
semilogx(f,10*log10(8*pi*S_pp_p/(20*10^-6)^2))
semilogx(f,10*log10(8*pi*S_pp_s/(20*10^-6)^2))
xlabel('f')
ylabel('S_pp')
legend('Total','pressure','suction')
fh = fh + 1;
end

