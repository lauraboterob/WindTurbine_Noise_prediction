function [fto,sTO] = CTOT_test(freq,spectrum)
% normalized 1/3 octave center freqs
	fref = [10 12.5 16 20, 25 31.5 40, 50 63 80, 100 125 160, 200 250 315, ...
    400 500 630, 800 1000 1250, 1600 2000 2500, 3150 4000 5000, ...
	6300 8000 10000, 12500 16000 20000 ];
	
ff = (1000).*((2^(1/3)).^[-20:13]); 	% Exact center freq. 	
a = sqrt(2^(1/3));	% 
f_lower_bound = ff./a;
%f_lower_bound = f_lower_bound(3:end);
f_higher_bound = ff.*a;
%f_higher_bound = f_higher_bound(3:end);
ind1 = find(f_higher_bound>min(freq));  ind1 = ind1(1); % indice of first value of  "f_higher_bound" above "min(freq)"
ind2 = find(f_lower_bound<max(freq));  ind2 = ind2(end); % indice of last value "f_lower_bound" below "max(freq)"
ind3 = (ind1:ind2);
for ci = 1:length(ind3)
    ind4 = find(freq>=f_lower_bound(ind3(ci)) & freq<=f_higher_bound(ind3(ci)));
    sTO(ci) = trapz(freq(ind4),spectrum(ind4));     %  1/3 octave value = averaged value of spectrum inside 1/3 octave band
    %sTO(ci) = sum(spectrum(ind4));     %  1/3 octave value = averaged value of spectrum inside 1/3 octave band
    fto(ci) = fref(ind3(ci));           % valid central frequency   1/3 octave 
end
end