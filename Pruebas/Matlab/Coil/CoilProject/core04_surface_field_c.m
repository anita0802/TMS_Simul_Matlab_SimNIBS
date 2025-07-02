%   This script plots the induced magnetic surface charge density 
%
%   Copyright SNM 2021

%%   Graphics

index           = [1:length(GEOM.t)];
temp            = mu0*cf(index);    %  magnetic charge density in Tesla
bemf2_graphics_surf_field_interp(P, t, temp, Indicator(index), 1);
title('Surface charge density (mu0*Mn) in T (weber per square meter)');

%%  Coil graphics 
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
view(10, 20)