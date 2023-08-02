function [R_dist,c_dist,thickness_dist,twist_dist,airfoil_dist] = Read_bladeinputs()
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
name_file = 'dataraw_bladeelement.csv';
% Import the data
tbl = readtable(['Inputs\' name_file], opts);

%% Convert to output type
R_dist = tbl.rR(4:end);
c_dist = tbl.chordlength(4:end);
thickness_dist = tbl.thicknessofchord(4:end);
twist_dist = tbl.twistangledeg(4:end);
airfoil_dist = tbl.airfoil(4:end);
%% Clear temporary variables
clear opts tbl
end

