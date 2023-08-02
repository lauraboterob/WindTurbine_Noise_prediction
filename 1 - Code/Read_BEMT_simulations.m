function [R_dist_Bemt,AoA_dist,V_app_dist,Phi_dist] = Read__BEMT_simulations()
%% Import data from text file
% Script for importing data from the following text file:
%
%    filename: P:\ET\EFD\Research\zEPHYR\19 - Codes\7 - Strip_theory_wind_turbine\Benchmark\Inputs\array_res_rigi (1).csv
%
% Auto-generated by MATLAB on 31-Jan-2023 16:11:40

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Radm", "Aoadeg", "Vappms", "Phideg", "Torsiondeg", "SecRotdeg"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
tbl = readtable("Inputs\array_res_rigi.csv", opts);
R_dist_Bemt = tbl.Radm(tbl.Radm>8);
AoA_dist = tbl.Aoadeg(tbl.Radm>8);
V_app_dist = tbl.Vappms(tbl.Radm>8);
Phi_dist   = tbl.Phideg(tbl.Radm>8);
%% Clear temporary variables
clear opts
end
