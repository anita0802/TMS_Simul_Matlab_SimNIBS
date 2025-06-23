%   This script plots magnetic flux in T just outside the core surface
%
%   Copyright SNM 2021

%%   Find the H-field just inside or just outside any model surface
index           = [1:length(GEOM.t)];
HpriP       = bemf3_inc_field_magnetic(strcoil, P, prec);                           %   Primary field anywhere at surface nodes
HpriS       = 1/3*(HpriP(t(:, 1), :) + HpriP(t(:, 2), :) + HpriP(t(:, 3), :));       %   Pimary field at the centers of surface facets
Hadd        = bemf4_surface_field_accurate(cf, Center, Area, EFX, EFY, EFZ, prec);

par = 1;    %      par=-1 -> H-field just inside surface; par=+1 -> E-field just outside surface     
H =  HpriS+ Hadd + par/(2)*normals.*repmat(cf, 1, 3);    %   full field
temp            = mu0*sqrt(dot(H, H, 2));    %  magnetic flux in Tesla
temp            = temp(index);

%%  Graphics
scale           = 0.75*max(temp);
temp(temp>scale)= scale; 
bemf2_graphics_surf_field_interp(P, t, temp, Indicator(index), 1);
title('Magnetic flux in T just outside the core surface');

%%  Coil graphics 
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
view(0, 0)