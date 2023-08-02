%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% This script calculates the far-field noise emmited%%%%%%%%%%%%%%
%%%%%%% by a wind turbine using the strip theory methodology %%%%%%%%%%%%%%
%%%%%%%%%% considering only leading- and trailing-edge noise %%%%%%%%%%%%%%
%%%%%%%%%% calculated by Amiet Theory %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Code developed during the PhD at the University of Twente, NL%%%
%%%%%%%%%% Contact: l.boterobolivar@gmail.com %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
tic
addpath('LE')
addpath('TE')
%% inputs
[fluid,inputs] = inputs_definition_StripTheory();
LE = inputs.LE;
B = inputs.B;
%% divide the blade into segments 
[c_dist, Ra_dist, twist_dist, airfoil_dist, AoA_dist,b_dist,U_dist,Re_dist] = blade_segments_logSpace_AR3(inputs);
%% loop to calculate each segment
Psi_vector = linspace(0,360,20);
Psi_vector = Psi_vector(1:end-1);
f = logspace(log10(5),log10(20000),1000);
%%
for k = 1:length(Psi_vector)
    Psi =  Psi_vector(k);
for i = 1:length(c_dist)
    c = c_dist(i);
    twist = twist_dist(i);
    airfoil = airfoil_dist(i);
    AoA = AoA_dist(i);
    b = b_dist(i);
    Ra = Ra_dist(i);
    [omega,omega_e(:,k),~,wswr(k,i),Mbc0Te(k,i,:)] = retarded_frequency(inputs,fluid,Psi,f,Ra);
    U = U_dist(i);
    [y1(k,i), y2(k,i), y3(k,i)] = Coordinates_definition(inputs,twist,AoA,Ra,Psi,Mbc0Te(k,i,:));
    if k == 1
    disp(b/c)
    Re = Re_dist(i);
    M = U/fluid.c0;
    xtr_s = 0.065;
    xtr_p = 0.065;
    xc = 0.95;
    [delta_s_s(i),delta_s_p(i),theta_s(i),theta_p(i),cf_s(i),cf_p(i),x_c,Cp,Ue_s(i),Ue_p(i),dcpdx_s(i),dcpdx_p(i)] = XFOIL_new_airfoil(airfoil,AoA,Re,M,xtr_p,xtr_p,c,xc);
    %boundary layer parameter for each side of the airfoil
    [delta_s(i),tau_w_s(i),u_t_s(i)] = Boundary_layer_characteristics(delta_s_s(i),theta_s(i),cf_s(i),U,fluid);
    [delta_p(i),tau_w_p(i),u_t_p(i)] = Boundary_layer_characteristics(delta_s_p(i),theta_p(i),cf_p(i),U,fluid);
    end 
    [S_pp_TE(i,:),S0(i,k),K_2_bar(i,k,:),I(i,k,:),Pi0_s(i,k,:)]  = TE_noise_Prediction(fluid,omega_e(:,k)',y1(k,i),y2(k,i),y3(k,i),U,airfoil,c,twist,AoA,b,delta_s(i),tau_w_s(i),u_t_s(i),delta_p(i),tau_w_p(i),u_t_p(i),Ue_s(i),Ue_p(i),dcpdx_s(i),dcpdx_p(i),delta_s_s(i),delta_s_p(i),cf_s(i),cf_p(i),theta_s(i),theta_p(i));
    if  LE == 1
    [S_pp_LE(i,:)] = LE_noise_Prediction(omega_e(:,k)',fluid,U,airfoil,b,c,y1(k,i),y2(k,i),y3(k,i),inputs.u_rms,inputs.L);
    S_pp_total(i,:) = (S_pp_TE(i,:) + S_pp_LE(i,:)).*(omega_e(:,k)'./omega).^2;
    else 
    S_pp_total(i,:) = (S_pp_TE(i,:)).*(omega_e(:,k)'./omega).^2;
   end 
end
    S_pp_blade(:,k) = sum(S_pp_total(:,:),1);  
end 
%% integrate over one revolution at each frequency
for j = 1:length(omega)
S_pp_rev(j) = B/((360)*pi/180)*trapz(Psi_vector*pi/(180),S_pp_blade(j,:));
end 
save('S_pp_WT_rev.mat','S_pp_rev')

%% dBA
Ra = 12194^2*f.^4./((f.^2+20.6^2).*sqrt((f.^2+107.7^2).*(f.^2+797.9^2)).*(f.^2+12194^2));
[~,pos_f] = min(abs(f-1000));
A = 20*log10(Ra)-20*log10(Ra(pos_f));
S_pp_dbA = 10*log10(4*pi*S_pp_rev/(20*10^-6)^2) + A;

%% Figure parameters
%parameters
font_size = 26;
line_width = 2;
x0=10;
y0=10;
width=1000;
height=0.35*1000/0.5;
marker_size = 5;

figure(1)
semilogx(f,S_pp_dbA,'-','linewidth',3,'DisplayName',['Uniform'])
hold on
ylabel('$L_p$ [dBA]','FontSize',font_size,'Interpreter','latex')
xlabel('$f$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
ax.XAxis.TickLabelInterpreter = 'latex';
ax.YAxis.TickLabelInterpreter = 'latex';
legend('show','Numcolumns',1,'location','Best','Interpreter','latex','FontSize',26);
grid on


figure(2)
semilogx(f,10*log10(4*pi*S_pp_rev/(2e-5)^2),'-','linewidth',3,'DisplayName',['Uniform'])
hold on
ylabel('$L_p$ [dB]','FontSize',font_size,'Interpreter','latex')
xlabel('$f$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
ax.XAxis.TickLabelInterpreter = 'latex';
ax.YAxis.TickLabelInterpreter = 'latex';
legend('show','Numcolumns',1,'location','Best','Interpreter','latex','FontSize',26);
grid on

[Fc,sortedData] = CTOT_test(f,4*pi*S_pp_rev);
Lp_onethird = 10*log10(sortedData/(20*10^-6)^2);
Ra = 12194^2*Fc.^4./((Fc.^2+20.6^2).*sqrt((Fc.^2+107.7^2).*(Fc.^2+797.9^2)).*(Fc.^2+12194^2));
[~,pos_Fc] = min(abs(Fc-1000));
A_onethird = 20*log10(Ra)-20*log10(Ra(pos_Fc));
Lp_onethird_dbA = Lp_onethird + A_onethird;
Lp_onethird_psd = 10*log10((10.^(sortedData(2:end)/10)/diff(Fc))/(20*10^-6)^2);
Lp_onethird_dbA_psd = Lp_onethird_psd + A_onethird(2:end);

%%
toc