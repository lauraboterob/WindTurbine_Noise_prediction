%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% CODE TO VALIDATE PHI_PP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get the data 
[File, Path] = uigetfile('.txt','select text file with validation data',...
    'MultiSelect','on');
Data = readmatrix([Path File]);
freq_erf = linspace(100,20000,1000);

%% plot the data
figure()
semilogx(freq_erf, 10*log10(abs(Data(:,1))),'DisplayName','Erfan')
hold on
semilogx(freq_erf,10*log10(S_pp),'DisplayName','Laura');
