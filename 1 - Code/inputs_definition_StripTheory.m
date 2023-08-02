function [fluid,input] = inputs_definition_StripTheory()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% fluid properties 
fluid           = struct; 
fluid.T         = 22;
fluid.Tk        = fluid.T+273.15;
fluid.P         = 100000;
fluid.ni        = 1.5e-5;
fluid.gamma     = 1.4;
fluid.R         = 287;
fluid.c0        = 343;%sqrt(fluid.gamma*fluid.R*fluid.Tk);
fluid.rho       = 1.225;
%fluid.rho       = fluid.P/(fluid.R*fluid.Tk);

%% Import bemt simulations conditions
input           = struct;
%read table 
input.rpm = 17; 
input.U = 9.5;
input.pitch = 5;
input.gamma = 0; % deformation of the blades
%% test case parameters
%default ans:
input.R0x        = 0;
input.R0y        = -80;
input.R0z        = 100;
input.Theta     = 60;
input.radio     = 46.5;
input.n         = 1000;
input.u_rms        = 10.7;
input.L      = 300;
input.LE = 1;
input.B = 3;
input.innitial_ratio = 9;
prompt         = {'U_inf [m/s]:'...
    'Mic position R0x [m]:', 'Mic position R0y [m]:','Mic position R0z [m]:',...
    'Pitch angle [degree]', 'wind turbine radio [m]',...
    'number of segments', 'Rotational speed [rpm]', 'Turbulence intensity [%]', 'Length scale [m]', 'Calculate LE noise? yes = 1; No = 0', 'Blades', 'Radial position where you want to calculate the noise [m]', 'Blades deformation [deg]'};
dlg_title      = 'Input';
num_lines      = 1;
defaultans     = {num2str(input.U),num2str(input.R0x),num2str(input.R0y),num2str(input.R0z)...
    ,num2str(input.pitch),num2str(input.radio),num2str(input.n),num2str(input.rpm),num2str(input.u_rms),num2str(input.L),num2str(input.LE),num2str(input.B),num2str(input.innitial_ratio),num2str(input.gamma)};
data           = inputdlg(prompt,dlg_title,num_lines,defaultans);
input.U        = str2double(data{1});
input.R0x       = str2double(data{2});
input.R0u       = str2double(data{3});
input.R0z       = str2double(data{4});
input.pitch    = str2double(data{5});
input.radio    = str2double(data{6});
input.n        = str2double(data{7});
input.rpm      = str2double(data{8});
input.u_rms        = str2double(data{9})*input.U/100;
input.L      = str2double(data{10});
input.LE      = str2double(data{11});
input.B      = str2double(data{12});
input.innitial_ratio = str2double(data{13});
input.gamma = str2double(data{14});
input.theta    = atand(input.R0z/input.R0x);

end

