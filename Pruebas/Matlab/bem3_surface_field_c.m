%   This script plots the induced surface charge density for
%   any brain compartment surface (plots the density + optionally
%   coil geometry).
%
%   Copyright SNM/WAW 2017-2020

%%   Graphics
tissue_to_plot = 'Brain';

objectnumber    = find(strcmp(tissue, tissue_to_plot));
temp            = eps0*c(Indicator==objectnumber);  % the real charge density is eps0*c

temp(temp>0.1*max(temp)) = 0.1*max(temp);
temp(temp<0.1*min(temp)) = 0.1*min(temp);

%%  Surface plot
figure; view(-118, 18);
bemf2_graphics_surf_field_interp(P, t, temp, Indicator, objectnumber);
title(strcat('Solution: Surface charge density in C/m^2 for ', tissue{objectnumber}));


%%  Coil graphics 
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 1);

%%  Core graphics
if size(fields(strcoil), 1)>7
    str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
    bemf2_graphics_base(strcoil.CoreP, strcoil.Coret, str);
end

%%  Line graphics
bemf1_graphics_lines(Nx, Ny, Nz, MoveX, MoveY, MoveZ, Target, handle, 'xyz');

%%  Surface plot
figure; view(-118, 18);
bemf2_graphics_surf_field_interp(P, t, temp, Indicator, objectnumber);
title(strcat('Solution: Surface charge density in C/m^2 for ', tissue{objectnumber}));

