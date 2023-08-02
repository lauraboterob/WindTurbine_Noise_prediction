function [blade] = Read_bladeinputs_AL_inst()
%% Setup the Import Options and import the data

opts = delimitedTextImportOptions("NumVariables", 5);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["rR", "chordlength", "thicknessofchord", "twistangledeg", "airfoil"];
opts.VariableTypes = ["double", "double", "double", "double", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "airfoil", "EmptyFieldRule", "auto");

% Import the data
name_file = 'dataraw_bladeelement.csv';
% Import the data
tbl = readtable(['Inputs\' name_file], opts);

%% Convert to output type
blade = struct;
blade.R_dist = tbl.rR(1:end);
blade.c_dist = tbl.chordlength(1:end);
blade.thickness_dist = tbl.thicknessofchord(1:end);
blade.twist_dist = tbl.twistangledeg(1:end);
blade.airfoil_dist = tbl.airfoil(1:end);

%% Clear temporary variables
clear opts tbl
end

