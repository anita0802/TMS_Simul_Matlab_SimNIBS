%   This script computes and plots the electric field just inside/outside
%   any brain compartment surface (plots the surface field + optionally
%   coil geometry).
%
%   Copyright SNM/WAW 2017-2020

%%   Find continuous contribution to surface fields
%   total E-field just inside/outside any model surface; 
tic
[Pot, Eadd]  = bemf4_surface_field_electric_accurate(c, Center, Area, EFX, EFY, EFZ, PF, prec);
fieldTime    = toc

%%   Find the E-field just inside or just outside any model surface
par = -1;    %      par=-1 -> E-field just inside surface; par=+1 -> E-field just outside surface     
E = Einc + Eadd + par/(2)*normals.*repmat(c, 1, 3);    %   full field
%   Select surface/interface and compute field magnitude (tangential or normal or total)

tissue_to_plot = 'Brain';
objectnumber= find(strcmp(tissue, tissue_to_plot));
E           = E(Indicator==objectnumber, :);
Normals     = normals(Indicator==objectnumber, :);
Enormal     = sum(E.*Normals, 2);       % this is a projection onto normal vector (directed outside!)
temp        = Normals.*repmat(Enormal, 1, 3);
Etangent    = E - temp;
Etangent    = sqrt(dot(Etangent, Etangent, 2));
Etotal      = sqrt(dot(E, E, 2));
clear e;
e.MAXEtotal     = max(Etotal);
e.MAXEnormal    = max(abs(Enormal));
e.MAXEtangent   = max(abs(Etangent)); e
temp = Etotal;

th = 0.5*max(temp);
temp(temp>th) = th;


%%   Shell graphics
figure; view(-118, 18);               
bemf2_graphics_surf_field_interp(P, t, temp, Indicator, objectnumber);
if par == +1; string = ' just outside'; end
if par == -1; string = ' just inside'; end
title(strcat('Solution: E-field (total, normal, or tang.) in V/m ', string, tissue{objectnumber}));

%%  Coil graphics 
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 1);

%%  Core graphics
if size(fields(strcoil), 1)>7
    str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
    bemf2_graphics_base(strcoil.CoreP, strcoil.Coret, str);
end

%%  Line graphics
bemf1_graphics_lines(Nx, Ny, Nz, MoveX, MoveY, MoveZ, Target, handle, 'xyz');

%%   Shell graphics separate
figure; view(-118, 18);             
bemf2_graphics_surf_field_interp(P, t, temp, Indicator, objectnumber);
if par == +1; string = ' just outside'; end
if par == -1; string = ' just inside'; end
title(strcat('Solution: E-field (total, normal, or tang.) in V/m ', string, tissue{objectnumber}));
