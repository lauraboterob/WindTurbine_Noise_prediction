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

%% Figure parameters
%parameters
font_size = 26;
line_width = 2;
x0=10;
y0=10;
width=1000;
height=0.35*1000/0.5;
marker_size = 5;
%% inputs
[fluid,inputs] = inputs_definition_StripTheory();
[inputs] = inputs_AL_results(inputs);
B = inputs.B; 
[blade] = Read_bladeinputs_AL_inst();
[blade] = blade_segments_logSpace_AR3_AL_inst(inputs,blade);
%% calculate the final position (ts) for one rotation
[psi_inn_blade1,psi_inn_blade2,psi_inn_blade3,ts_final,conv,rot_speed] = calculate_ts(inputs);
%% define f
f = logspace(log10(5),log10(20000),1000);
%% Load the results
AL_data = dir('..\2 - AL_inputs\wt_tower\');
%%
for rot = 1:inputs.rot
    ts = inputs.ts_in;
    k = 1;
    psi_blade_1(k) = psi_inn_blade1;
    psi_blade_2(k) = psi_inn_blade2;
    psi_blade_3(k) = psi_inn_blade3;
    while ts <= ts_final   
    psi_blades = [psi_blade_1(k) psi_blade_2(k) psi_blade_3(k)];
        for i = 1:B
            check_file = 0;
            %% find the file for inputs
            for kk = 1:length(AL_data)
                if contains(AL_data(kk).name,strcat('actuatorBench',num2str(rot),'T'))...
                        & contains(AL_data(kk).name,strcat('Line_instant_00',num2str(i)))...
                        & contains(AL_data(kk).name,num2str(ts))
                    AL_file = [AL_data(kk).folder '\' AL_data(kk).name];
                    check_file = 1;
                    break;
                end
            end 
            if check_file ~= 1
                break;
            end 
          [S_pp_blade(i,k,:)] = Far_field_noise_blade(psi_blades(i)*180/pi,AL_file,inputs,blade,f,fluid);
        end
         if check_file ~= 1
            break;
         end    
    k = k + 1;
    ts = ts + inputs.delta_ts;
    psi_blade_1(k) = psi_inn_blade1 + rot_speed*(ts-inputs.ts_in)*(1/conv);
    psi_blade_2(k) = psi_inn_blade2 + rot_speed*(ts-inputs.ts_in)*(1/conv);
    psi_blade_3(k) = psi_inn_blade3 + rot_speed*(ts-inputs.ts_in)*(1/conv);
    end 
    psi = [psi_blade_1;psi_blade_2;psi_blade_3];
    for i = 1:B
        for j = 1:length(f)
         S_pp_total_rot_blade(i,j) = (1/(psi_blade_1(end-1)-psi_blade_1(1)))*trapz(psi(i,1:end-1),S_pp_blade(i,:,j));
        end 
    end
    S_pp_total_rot(rot,:) = sum(S_pp_total_rot_blade(:,:),1);
    if isnan(S_pp_total_rot)
        break
    end 
    %% dBA
    Ra = 12194^2*f.^4./((f.^2+20.6^2).*sqrt((f.^2+107.7^2).*(f.^2+797.9^2)).*(f.^2+12194^2));
    [~,pos_f] = min(abs(f-1000));
    A = 20*log10(Ra)-20*log10(Ra(pos_f));
    S_pp_dbA_total_rot(rot,:)  = 10*log10(4*pi*S_pp_total_rot(rot,:)/(20*10^-6)^2) + A;

figure(100)
semilogx(f,S_pp_dbA_total_rot(rot,:),'-','linewidth',3,'DisplayName',['Instantaneous results'])
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


figure(200)
semilogx(f,10*log10(4*pi*S_pp_total_rot(rot,:)/(20*10^-6)^2),'-','linewidth',3,'DisplayName',['Instantaneous results'])
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

[Fc,sortedData] = CTOT_test(f,4*pi*S_pp_total_rot(rot,:));
%Lp_onethird = 10*log10(10.^(sortedData/10)/(20*10^-6)^2);
Lp_onethird = 10*log10(sortedData/(20*10^-6)^2);
Ra = 12194^2*Fc.^4./((Fc.^2+20.6^2).*sqrt((Fc.^2+107.7^2).*(Fc.^2+797.9^2)).*(Fc.^2+12194^2));
[~,pos_Fc] = min(abs(Fc-1000));
A_onethird = 20*log10(Ra)-20*log10(Ra(pos_Fc));
Lp_onethird_dbA = Lp_onethird + A_onethird;

figure(300)
semilogx(Fc,Lp_onethird_dbA(rot,:)+6,'-','linewidth',3,'DisplayName',['Instantaneous results'])
hold on
ylabel('$L_{p,1/3}$ [dBA]','FontSize',font_size,'Interpreter','latex')
xlabel('$Fc$ [Hz]','Interpreter','latex','FontSize',font_size,'Interpreter','latex')
set(gca,'FontSize',font_size)
set(gcf,'position',[x0,y0,width,height])
ax = gca;
ax.XAxis.TickLabelInterpreter = 'latex';
ax.YAxis.TickLabelInterpreter = 'latex';
legend('show','Numcolumns',1,'location','Best','Interpreter','latex','FontSize',26);
grid on
end 
save('S_pp_blade_inst.mat','S_pp_blade')
save('S_pp_total_rot_inst.mat','S_pp_total_rot')
save('S_pp_total_rot_blade_inst.mat','S_pp_total_rot_blade')
toc