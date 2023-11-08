function  [y1, y2, y3,dist] = Coordinates_definition(inputs,twist,AoA,Ra,Psi,Mbc0Te)

%% observer coordinates - in the plane XZ
X_obs = inputs.R0x;
Y_obs = inputs.R0y;
Z_obs = inputs.R0z;
Angle = inputs.pitch+twist;

% %% move to the moving reference frame
% X_obs = inputs.R0*sind(inputs.Theta);
% Y_obs = 0;
% Z_obs = inputs.R0*cosd(inputs.Theta);
% x1_obs = inputs.R0*(sind(inputs.Theta)*cosd(Angle)*cosd(Psi)+inputs.R0*cosd(inputs.Theta)*sind(Angle));
% x2_obs = -inputs.R0*sind(inputs.Theta)*sind(Psi);
% x3_obs = inputs.R0*(-sind(inputs.Theta)*sind(Angle)*cosd(Psi)inputs.R0*cosd(inputs.Theta)*cosd(Angle));
% %% Location of the midle of the Trailing edge 
% y1 = x1_obs - 0;
% y2 = x2_obs - Ra;
% y3 = x3_obs - 0;
Rr = [X_obs; Y_obs; Z_obs] - Mbc0Te(:);
Mz = [cosd(Psi) sind(Psi) 0;...
    -sind(Psi) cosd(Psi) 0;...
    0 0 1];
Rb = Mz*Rr;
d = [0;-Ra;0];
Rs = Rb + d;
My = [cosd(Angle) 0 sind(Angle);...
    0 1 0;...
    -sind(Angle) 0 cosd(Angle)];
Mx = [1 0 0; 0 cosd(inputs.gamma) sind(inputs.gamma); 0 -sind(inputs.gamma) cosd(inputs.gamma)];
Robs = Mx*(My*(Mz*Rr+d));
    
y1 = Robs(1);
y2 = Robs(2);
y3 = Robs(3);

dist = sqrt(y1^2+y2^2+y3^2);
end


