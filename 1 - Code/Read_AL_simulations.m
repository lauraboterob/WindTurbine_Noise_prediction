function [R_dist_Bemt,AoA_dist,V_app_dist,Re_dist] = Read_AL_simulations()
% Import the data
filepath = 'Inputs\';
filename = 'actuatorBench1T_Actuator_Line_average.dat';
data = importdata(fullfile(filepath, filename));

% extract the header and data
header = data.textdata;
datamatrix = data.data;

R_dist_Bemt = datamatrix(:,1);
V_app_dist= datamatrix(:,2);
AoA_dist =datamatrix(:,3);
Re_dist = datamatrix(:,4);
end
