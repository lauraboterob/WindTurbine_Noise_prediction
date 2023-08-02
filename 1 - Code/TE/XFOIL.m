function [DSTRS,DSTRP,THETAS,THETAP,CFS,CFP,x_c,Cp,Ue_s,Ue_p, dcpdx_s, dcpdx_p] = XFOIL(NACADIG,ALPSTAR,Re,Mach,xtr_s,xtr_p,C,pos)
% This function calculates the displacement thickness using XFOIL.
% The turbulence intensity is set at 0.07

fid = fopen(['xfoil_ifile.txt'],'w');
fprintf(fid,'%s\n',NACADIG);
fprintf(fid,'\n\noper\n');
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
fprintf(fid,['N ' num2str(N_crit) '\n\n']);
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
fclose(fid);


cmd = sprintf('xfoil.exe < xfoil_ifile.txt', cd);
[status,result] = system(cmd);

if contains(result(end-500:end),'failed')
        disp('XFoil Failed to Converge, Please check Input Parameters')
else
    disp('XFoil Converged')
    fid = fopen('XFOIL_Output','r');
    D = textscan(fid,'%f%f%f%f%f%f%f%f','Delimiter',' ','MultipleDelimsAsOne',true,'CollectOutput',1,'HeaderLines',1);
    fclose(fid);
    D = D{1,1};
    DSTAR_all = D(:,5);
     
    k = strfind(result,'Number of panel nodes');
    DSTRP = DSTAR_all(str2double(result((k+28):(k+30))))*C;
  
    s      = D(:,1);
    xc     = D(:,2);
    [~,index] = min(abs(pos-xc));
    index
    yc     = D(:,3);
    Ue     = D(:,4);
    theta  = D(:,6);
    THETAS = theta(index)*C;
    THETAP = theta(str2double(result((k+28):(k+30)))-index+1)*C;
    DSTRS = DSTAR_all(index)*C;
    cf     = D(:,7);
    CFS = cf(index);
    CFP = cf(str2double(result((k+28):(k+30)))-index+1);
    Ue_s = Ue(index);
    Ue_p = -Ue(str2double(result((k+28):(k+30)))-index+1);
    % Load Cp data
    D2 = dlmread('XFOIL_CP_Output','',3,0);
    Cp = D2(:,3);
    x_c = D2(:,1);
    N_points = str2double(result((k+28):(k+30)));
    
    dcpdx_s = (Cp(index+1)-Cp(index))/(x_c(index+1)-x_c(index));
    dcpdx_p = (Cp(N_points-index+1+1)-Cp(N_points-index+1))...
        /(x_c(N_points-index+1+1)-x_c(N_points-index+1));
    
end