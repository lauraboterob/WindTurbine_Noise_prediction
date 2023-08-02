function [DSTRS,DSTRP,THETAS,THETAP,CFS,CFP,x_c,Cp,Ue_s,Ue_p, dcpdx_s, dcpdx_p] = XFOIL_new_airfoil(NACADIG,ALPSTAR,Re,Mach,xtr_s,xtr_p,C,pos)
% This function calculates the displacement thickness using XFOIL.
% The turbulence intensity is set at 0.07
%ALPSTAR=4.53;
fid = fopen(['xfoil_ifile.txt'],'w');
fprintf(fid,'PLOP\n');
fprintf(fid,'G F\n\n');
fprintf(fid,'load\n');
fprintf(fid,'%s',NACADIG);
fprintf(fid,'%s','.dat');
fprintf(fid,'\n oper\n');
% Set Reynolds and Mach
fprintf(fid,'visc\n');
fprintf(fid,'%g\n',Re);
fprintf(fid,'mach %g\n',Mach);
fprintf(fid,'iter %g\n',1000);
% Set turbulence intensity
Tu     = 0.07;
N_crit = -8.43-2.4*log(Tu/100);
%N_crit = 1;
fprintf(fid,'vpar\n');
fprintf(fid,['N \n' num2str(N_crit) '\n\n']);
if xtr_s==1
else
   fprintf(fid,'vpar\n');
   fprintf(fid,'xtr\n');
   fprintf(fid,'%g\n',xtr_s);
   fprintf(fid,'%g\n\n',xtr_p);
end
fprintf(fid,'alfa %g\n',ALPSTAR);
fprintf(fid,'cpwr  %s\n','XFOIL_CP_Output');
fprintf(fid,'DUMP %s\n','XFOIL_Output');

fprintf(fid,'\n \n %s','quit');
fclose(fid);
cmd = sprintf('xfoil.exe < xfoil_ifile.txt', cd);
[status,result] = system(cmd);

if contains(result,'command not recognized')
    disp(' command not recognized ')
end
index_n = strfind(result,'Number of input coordinate points: ');
n_nodes = str2num(result(index_n+35:index_n+35+3));
if contains(result(end-1000:end),'Convergence failed')
        disp('XFoil Failed to Converge, Please check Input Parameters')
        [DSTRS,DSTRP,THETAS,THETAP,CFS,CFP,x_c,Cp,Ue_s,Ue_p, dcpdx_s, dcpdx_p] = XFOIL_new_airfoil(NACADIG,ALPSTAR+0.02,Re,Mach,xtr_s,xtr_p,C,pos);
else
    disp('XFoil Converged')
    fid = fopen('XFOIL_Output','r');
    D = textscan(fid,'%f%f%f%f%f%f%f%f','Delimiter',' ','MultipleDelimsAsOne',true,'CollectOutput',1,'HeaderLines',1);
    fclose(fid);
    D = D{1,1};
    s      = D(:,1);
    xc     = D(:,2);
    [~,index] = min(abs(pos-xc(1:round(n_nodes/2))));
    cf     = D(:,7);
    CFS = cf(index);
    if CFS<=1e-3
    index = find(sign(cf-1e-3)==1);
    index = index(1);   
    fprintf('BL parameters at %f',xc(index))
    end 
    DSTAR_all = D(:,5);
    CFS = cf(index);
    yc     = D(:,3);
    Ue     = D(:,4);
    theta  = D(:,6);
    THETAS = theta(index)*C;
    THETAP = theta(n_nodes-index+1)*C;
    DSTRS = DSTAR_all(index)*C;
    DSTRP = DSTAR_all(n_nodes-index+1)*C;
    CFP = cf(n_nodes-index+1);
    if CFP<=0
    index = find(sign(cf)==1);
    index = index(end-1);   
    fprintf('BL parameters on the PS at %f',xc(index))
    end 
    CFP = cf(index);
    Ue_s = Ue(index);
    Ue_p = -Ue(n_nodes-index+1);
    % Load Cp data
    D2 = dlmread('XFOIL_CP_Output','',3,0);
    Cp = D2(:,3);
    x_c = D2(:,1);
    N_points = n_nodes;
    
    dcpdx_s = (Cp(index-1)-Cp(index+1))/(x_c(index-1)-x_c(index+1));
    dcpdx_p = (Cp(N_points-index+1+1)-Cp(N_points-index+1-1))...
        /(x_c(N_points-index+1+1)-x_c(N_points-index+1-1));
    
 delete('XFOIL_CP_Output')
 delete('XFOIL_Output')
end 
end