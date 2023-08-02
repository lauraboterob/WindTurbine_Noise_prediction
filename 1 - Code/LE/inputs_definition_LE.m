function [input] = inputs_definition_LE(fluid,U,airfoil,b,c,y1,y2,y3,u_rms,LE)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
input           = struct;
input.perfil    = airfoil;
input.chord     = c;
input.semichord = input.chord/2;
input.span      = b;
input.U         = U;
input.x         = y1;
input.y         = y2;
input.z         = y3;
input.urms      = u_rms;
input.Lambda    = LE;
input.model     = 'von Karman'; %% change for 'Liepmann' or 'TUD'
input.correction = 'No-Correction'; %% Change for 'Roger-Moreau' or 'Dissipation-range'
input.Ky       = NaN;
input.M        = U/fluid.c0;
end

