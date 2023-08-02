function plots_striptheory(f,S_pp_total,strip)

fh = 1;
figure(fh)
semilogx(f,10*log10(8*pi*S_pp_total/(20*10^-6)^2),'DisplayName',num2str(strip.n))
hold on
xlabel('f')
ylabel('S_pp_{total}')
fh = fh + 1;
end

