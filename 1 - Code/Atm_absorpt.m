function [a] = Atm_absorpt(f)
T = 15+273.15;
Tr = 20+273.15;
Pa = 98000;
Pr = 101325;
v = -6.8346*(273.16/T)^1.261 +4.6151;
PsatPr = 10^v;
hrel = 86;
h = hrel*PsatPr*(Pa/Pr)^(-1);
frN = (T/Tr)^(-1/2)*(Pa/Pr)*(9+280*h*exp(-4.170*((T/Tr)^(-1/3)-1)));
fro = (Pa/Pr)*(24+(((4.04*10^4*h)*(0.02+h))/(0.391+h)));
a = 8.686*f.^2.*((1.84*10^(-11)*(Pa/Pr)^(-1)*(T/Tr)^(1/2))+(T/Tr)^(-5/2)*(0.01275*exp(-2239.1/T).*(fro./(fro^2+f.^2))+...
    0.1068*exp(-3352/T).*(frN./(frN^2+f.^2))));
end
