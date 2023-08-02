%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% This script calculates the far-field noise emmited%%%%%%%%%%%%
%%%%%%%
%%% by a blade using the strip theory methodology %%%%%%%%%%%%%%%
%%%%%%%%%% Proposed by Rozenberg 2007 and Amiet theory %%%%%%%%%%%%%%%%%
%%%%%%%%%% Extension proposed by Roger-Moreau 2005 %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% l.boterobolivar@utwente.nl %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
tic
addpath('LE')
addpath('TE')


%% inputs
[fluid,inputs] = inputs_definition_StripTheory();
inputs.n = 45;
LE_calc = 1; % 1 if you want to also predict LE noise
B = 3; %number of blades
%% divide the blade into segments 
%[c_dist, Ra_dist, twist_dist, airfoil_dist, AoA_dist,b_dist] = blade_segments(inputs);
[c_dist, Ra_dist, twist_dist, airfoil_dist, AoA_dist,b_dist,U_dist,Re_dist] = blade_segments_logSpace_AR3(inputs);

%% loop to calculate each segment
Psi_vector = linspace(37,390,45);
Psi_vector = Psi_vector(1:end-1);
f = logspace(log10(5),log10(20000),1000);
%f = experiments(:,1)';
%%
for k = 1:length(Psi_vector)
    k
    Psi =  Psi_vector(k);
for i = 1:length(c_dist)
%     if k == 1
%     %% Wall pressure PSD
%     [Phi_pp_s(i,:),Phi_pp_p(i,:)] = surface_pressure_spectrum(omega,inputs,fluid,'Lee');
%     end 
    c = c_dist(i);
    twist = twist_dist(i);
    airfoil = airfoil_dist(i);
    AoA = AoA_dist(i);
    b = b_dist(i);
    Ra = Ra_dist(i);
    [omega,omega_e,~,wswr(k,i),Mbc0Te(k,i,:)] = retarded_frequency(inputs,fluid,Psi,f,Ra);
    U = U_dist(i);
    [y1(k,i), y2(k,i), y3(k,i)] = Coordinates_definition(inputs,twist,AoA,Ra,Psi,Mbc0Te(k,i,:));
    if k == 1
    disp(b/c)
    Re = Re_dist(i);
    M = U/fluid.c0;
    [delta_s_s(i),delta_s_p(i),theta_s(i),theta_p(i),cf_s(i),cf_p(i),x_c,Cp,Ue_s(i),Ue_p(i),dcpdx_s(i),dcpdx_p(i)] = XFOIL_new_airfoil(airfoil,AoA,Re,M,0.065,0.065,c,0.97);
    %boundary layer parameter for each side of the airfoil
    [delta_s(i),tau_w_s(i),u_t_s(i)] = Boundary_layer_characteristics(delta_s_s(i),theta_s(i),cf_s(i),U,fluid);
    [delta_p(i),tau_w_p(i),u_t_p(i)] = Boundary_layer_characteristics(delta_s_p(i),theta_p(i),cf_p(i),U,fluid);
    end 
    [S_pp_TE(i,k,:),S0(i,k),K_2_bar(i,k,:),I(i,k,:),Pi0_s(i,k,:)]  = TE_noise_Prediction(fluid,omega_e,y1(k,i),y2(k,i),y3(k,i),U,airfoil,c,twist,AoA,b,delta_s(i),tau_w_s(i),u_t_s(i),delta_p(i),tau_w_p(i),u_t_p(i),Ue_s(i),Ue_p(i),dcpdx_s(i),dcpdx_p(i),delta_s_s(i),delta_s_p(i),cf_s(i),cf_p(i),theta_s(i),theta_p(i)).*(omega_e./omega)'.^2;
    %[S_pp_TE(i,:),S0(i,k),K_2_bar(i,k,:),I(i,k,:),Pi0_s(i,k,:),temp(i,k,:)]  = TE_noise_Prediction(fluid,omega_e(:,k)',y1(k,i),y2(k,i),y3(k,i),U,airfoil,c,twist,AoA,b); 
    if LE_calc == 1
    [S_pp_LE(i,k,:)] = LE_noise_Prediction(omega_e',fluid,U,airfoil,b,c,y1(k,i),y2(k,i),y3(k,i),inputs.u_rms,inputs.L).*(omega_e./omega)'.^2;
    S_pp_total(i,k,:) = (S_pp_TE(i,k,:) + S_pp_LE(i,k,:));
    temporal = squeeze(S_pp_total(i,k,:)); %.*(omega_e./omega)'.^2;
    S_pp_total(i,k,:) = temporal;
    else 
    temporal = squeeze(S_pp_TE(i,k,:)).*(omega_e./omega)'.^2;
    S_pp_total(i,k,:) = temporal; % (S_pp_TE(i,k,:)).*(omega_e./omega)'.^2;
    end 
end 
    S_pp_blade(:,k) = sum(S_pp_total(:,k,:),1);
end 

%% integrate over one revolution at each frequency
for j = 1:length(omega)
S_pp_rev(j) = B/((390-37)*pi/180)*trapz(Psi_vector*pi/(180),S_pp_blade(j,:));
end 

%% integrate over one revolution at each each segment
for i = 1:length(c_dist)
    for j = 1:length(omega)
    S_pp_rev_seg(i,j) = B/(360*pi/180)*trapz(Psi_vector*pi/(180),S_pp_total(i,:,j));
    S_pp_rev_seg_LE(i,j) = B/(360*pi/180)*trapz(Psi_vector*pi/(180),S_pp_LE(i,:,j));
    S_pp_rev_seg_TE(i,j) = B/(360*pi/180)*trapz(Psi_vector*pi/(180),S_pp_TE(i,:,j));
    end 
end

%% for doing the check
s_pp_rev_sum_seg = sum(S_pp_rev_seg,1); %this should be equal to S_pp_rev

%% dBA
Ra = 12194^2*f.^4./((f.^2+20.6^2).*sqrt((f.^2+107.7^2).*(f.^2+797.9^2)).*(f.^2+12194^2));
[~,pos_f] = min(abs(f-1000));
A = 20*log10(Ra)-20*log10(Ra(pos_f));
S_pp_dbA = 10*log10(4*pi*S_pp_rev/(20*10^-6)^2) + A;
s_pp_rev_sum_seg_dbA = 10*log10(4*pi*s_pp_rev_sum_seg/(20*10^-6)^2) + A;

%% Figure parameters
%parameters
font_size = 26;
line_width = 2;
x0=10;
y0=10;
width=1000;
height=0.35*1000/0.5;
marker_size = 5;
File_out = 'NREL_TE_LE_for_segment';

% figure(1)
% semilogx(f,S_pp_dbA,'-','linewidth',3,'DisplayName',['$n~=~$' num2str(length(c_dist))])
% hold on
% semilogx(f,s_pp_rev_sum_seg_dbA,'-','linewidth',3,'DisplayName',['$n~=~$' num2str(length(c_dist))])
% ylabel('$L_p$ [dBA]','FontSize',font_size,'Interpreter','latex')
% xlabel('$f$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
% set(gca,'FontSize',font_size)
% set(gcf,'position',[x0,y0,width,height])
% ax = gca;
% ax.XAxis.TickLabelInterpreter = 'latex';
% ax.YAxis.TickLabelInterpreter = 'latex';
% legend('show','Numcolumns',1,'location','Best','Interpreter','latex','FontSize',26);
% grid on
% saveas(gcf,['../3 - Results/' File_out 'dbA.fig']);
% saveas(gcf,['../3 - Results/' File_out 'dbA.png']);
% saveas(gcf,['../3 - Results/' File_out 'dbA.eps'],'epsc');

for i = 1:length(c_dist)
[Fc,sortedData(i,:)] = CTOT_test(f,4*pi*S_pp_rev_seg(i,:));
%Lp_onethird = 10*log10(10.^(sortedData/10)/(20*10^-6)^2);
Lp_onethird = 10*log10(sortedData(i,:)/(20*10^-6)^2);
Ra = 12194^2*Fc.^4./((Fc.^2+20.6^2).*sqrt((Fc.^2+107.7^2).*(Fc.^2+797.9^2)).*(Fc.^2+12194^2));
[~,pos_Fc] = min(abs(Fc-1000));
A_onethird = 20*log10(Ra)-20*log10(Ra(pos_Fc));
Lp_onethird_dbA_total(i,:) = Lp_onethird(i,:) + A_onethird;
temp = 10.^(Lp_onethird_dbA_total(i,:)/10)*(20*10^-6)^2;
temp2 = sum(temp);
OASPL_total(i) = 10*log10(temp2/(20*10^-6)^2);
end 


for i = 1:length(c_dist)
[Fc,sortedData(i,:)] = CTOT_test(f,4*pi*S_pp_rev_LE(i,:));
%Lp_onethird = 10*log10(10.^(sortedData/10)/(20*10^-6)^2);
Lp_onethird = 10*log10(sortedData(i,:)/(20*10^-6)^2);
Ra = 12194^2*Fc.^4./((Fc.^2+20.6^2).*sqrt((Fc.^2+107.7^2).*(Fc.^2+797.9^2)).*(Fc.^2+12194^2));
[~,pos_Fc] = min(abs(Fc-1000));
A_onethird = 20*log10(Ra)-20*log10(Ra(pos_Fc));
Lp_onethird_dbA_LE(i,:) = Lp_onethird(i,:) + A_onethird;
temp = 10.^(Lp_onethird_dbA_LE(i,:)/10)*(20*10^-6)^2;
temp2 = sum(temp);
OASPL_LE(i) = 10*log10(temp2/(20*10^-6)^2);
end 

for i = 1:length(c_dist)
[Fc,sortedData(i,:)] = CTOT_test(f,4*pi*S_pp_rev_TE(i,:));
%Lp_onethird = 10*log10(10.^(sortedData/10)/(20*10^-6)^2);
Lp_onethird = 10*log10(sortedData(i,:)/(20*10^-6)^2);
Ra = 12194^2*Fc.^4./((Fc.^2+20.6^2).*sqrt((Fc.^2+107.7^2).*(Fc.^2+797.9^2)).*(Fc.^2+12194^2));
[~,pos_Fc] = min(abs(Fc-1000));
A_onethird = 20*log10(Ra)-20*log10(Ra(pos_Fc));
Lp_onethird_dbA_TE(i,:) = Lp_onethird(i,:) + A_onethird;
temp = 10.^(Lp_onethird_dbA_TE(i,:)/10)*(20*10^-6)^2;
temp2 = sum(temp);
OASPL_TE(i) = 10*log10(temp2/(20*10^-6)^2);
end 

figure(2)
semilogx(f,Lp_onethird_dbA_TE,'-','linewidth',3,'DisplayName',['TE'])
hold on
semilogx(f,Lp_onethird_dbA_LE,'-','linewidth',3,'DisplayName',['LE'])
semilogx(f,Lp_onethird_dbA_total,'-','linewidth',3,'DisplayName',['Total'])
ylabel('$L_p$ [dBA]','FontSize',font_size,'Interpreter','latex')
xlabel('$f$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
ax.XAxis.TickLabelInterpreter = 'latex';
ax.YAxis.TickLabelInterpreter = 'latex';
legend('show','Numcolumns',1,'location','Best','Interpreter','latex','FontSize',26);
grid on
saveas(gcf,['../4 - Results/' File_out 'dbA.fig']);
saveas(gcf,['../4 - Results/' File_out 'dbA.png']);
saveas(gcf,['../4 - Results/' File_out 'dbA.eps'],'epsc');

figure(3)
plot(Ra_dist/inputs.radio,OASPL_total,'o-','color',[0 0 0],'Markersize',8,'MarkerFacecolor',[0 0 0])
hold on
plot(Ra_dist/inputs.radio,OASPL_LE,'o-','color',[0 0 0],'Markersize',8,'MarkerFacecolor',[0 0 0])
plot(Ra_dist/inputs.radio,OASPL_TE,'o-','color',[0 0 0],'Markersize',8,'MarkerFacecolor',[0 0 0])
ylabel('$OASPL$ [dBA]','FontSize',font_size,'Interpreter','latex')
xlabel('$r/R$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
ax.XAxis.TickLabelInterpreter = 'latex';
ax.YAxis.TickLabelInterpreter = 'latex';
legend('show','Numcolumns',1,'location','Best','Interpreter','latex','FontSize',26);
grid on
saveas(gcf,['../3 - Results/' File_out 'OSAPL_vs_rR.fig']);
saveas(gcf,['../3 - Results/' File_out 'OSAPL_vs_rR.png']);
saveas(gcf,['../3 - Results/' File_out 'OSAPL_vs_rR.eps'],'epsc');

figure(4)
contourf(Fc(2:end),Ra_dist/inputs.radio,Lp_onethird_dbA_total(:,2:end))
ylabel('$r/R$ [-]','FontSize',font_size,'Interpreter','latex')
xlabel('$F_c$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
ax.XAxis.TickLabelInterpreter = 'latex';
ax.YAxis.TickLabelInterpreter = 'latex';
ax.XAxis.Scale = 'Log';
% 

figure(5)
contourf(Fc(2:end),Ra_dist/inputs.radio,Lp_onethird_dbA_LE(:,2:end))
ylabel('$r/R$ [-]','FontSize',font_size,'Interpreter','latex')
xlabel('$F_c$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
ax.XAxis.TickLabelInterpreter = 'latex';
ax.YAxis.TickLabelInterpreter = 'latex';
ax.XAxis.Scale = 'Log';

figure(6)
contourf(Fc(2:end),Ra_dist/inputs.radio,Lp_onethird_dbA_TE(:,2:end))
ylabel('$r/R$ [-]','FontSize',font_size,'Interpreter','latex')
xlabel('$F_c$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
ax.XAxis.TickLabelInterpreter = 'latex';
ax.YAxis.TickLabelInterpreter = 'latex';
ax.XAxis.Scale = 'Log';

figure(7)
h = polarplot(-psi_vector*pi/180,OASPL_total,'d','DisplayName','Average')
color = get(h,'color')
h.MarkerFaceColor = color;
hold on
%rlim([40 50])
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
matlab.graphics.axis.PolarAxes.TickLabelInterpreter = 'latex';

% end 
toc