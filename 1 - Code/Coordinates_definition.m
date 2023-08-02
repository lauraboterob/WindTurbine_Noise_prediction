function  [y1, y2, y3] = Coordinates_definition(inputs,twist,AoA,Ra,Psi,Mbc0Te)

%% observer coordinates - in the plane XZ
X_obs = inputs.R0x;
Y_obs = inputs.R0y;
Z_obs = inputs.R0z;
Angle = inputs.pitch+twist; % if you want to align with the flow and not the airfoil chord you should sum the AoA here. 
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
end


