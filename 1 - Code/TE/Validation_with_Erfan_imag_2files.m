%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% CODE TO VALIDATE PHI_PP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Get the data 
[File, Path] = uigetfile('.txt','select text file with validation data',...
    'MultiSelect','on');
Data_1 = readmatrix([Path File]);
freq_erf = linspace(100,20000,1000);

%% Get the data 
[File, Path] = uigetfile('.txt','select text file with validation data',...
    'MultiSelect','on');
Data_2 = readmatrix([Path File]);

Data = Data_1(4001:5000,1)+Data_2(4001:5000,1);

%% plot the data
figure()
semilogx(freq_erf, 10*log10(abs(Data)),'DisplayName','Erfan')
hold on
semilogx(f,10*log10(abs(squeeze(I(1,5,:)))),'DisplayName','Laura')
