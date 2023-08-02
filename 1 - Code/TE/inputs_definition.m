function [fluid,input] = inputs_definition()
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
fluid.c0        = sqrt(fluid.gamma*fluid.R*fluid.Tk);
fluid.rho       = 1.181;
%fluid.rho       = fluid.P/(fluid.R*fluid.Tk);

%% test case parameters
%default ans:
input.U         = 56;
input.R0        = 1;
input.Theta     = 20;
input.beta      = 20;
input.radio     = 1;
input.n         = 7;
input.rpm       = 600;

prompt         = {'U_inf [m/s]:'...
    'Mic position R0 [m]:', 'Mic position theta [degree]:',...
    'Stagger angle [degree]', 'wind turbine radio [m]',...
    'number of segments', 'Rotational speed [rpm]'
};
dlg_title      = 'Input';
num_lines      = 1;
defaultans     = {num2str(input.U),num2str(input.R0),num2str(input.Theta)...
 ,num2str(input.radio),num2str(input.n)};
data           = inputdlg(prompt,dlg_title,num_lines,defaultans);
input.U        = str2double(data{1});
input.R0       = str2double(data{2});
input.Theta    = str2double(data{3});
input.beta     = str2double(data{4});
input.radio    = str2double(data{5});
input.radio    = str2double(data{6});
end

