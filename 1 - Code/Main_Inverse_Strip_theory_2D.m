%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the main script to calculate the trailing edge noise of an airfoil
% using inverse strip theory of a 2D airofil.
% The trailing edge noise is calculated based on
% the theory of Roger-Moreu 2005. 
% In this code, the back scattering effect is also taken into account. 
% Laura Botero Bolívar - University of Twente 
% l.boterobolivar@utwente.nl
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Inputs for the strip theory
[Strip,fluid,input] = inputs_definition_StripTheory();

%% 
input.span     = input.span_total;

input_large    = struct;
input_large    = input;
input_large.span = 10; % 1m is enough to calculate amiet theory
input_in       = struct;
input_in       = input;
input_in.span  = input_large.span  - input.span/Strip.n;

%% Calculate the noise of each strip

    for j = 1:Strip.n
    [f, S_pp_large(j,:)] = TE_noise_Prediction(input_large,fluid);
    [~, S_pp_in(j,:)] = TE_noise_Prediction(input_in,fluid);
    S_pp(j,:) = S_pp_large(j,:) - S_pp_in(j,:); 
    end 
   %% Sum Each part 
if Strip.n == 1
    S_pp_total = S_pp;
else 
S_pp_total = sum(S_pp);
end 

%% plots
plots_striptheory(f,S_pp_total,Strip);