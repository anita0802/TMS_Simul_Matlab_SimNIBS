%   This script accurately computes and displays magnetic fields sampled on
%   a line via the FMM method with accurate neighbor integration
%
%   Copyright SNM 2021

load coil;

%%  Post processing parameters
component   = 4;        %   field component to be plotted (1, 2, 3 or x, y, z, or 4 - total) 
temp        = ['x' 'y' 'z' 't'];
label       = temp(component);

%%  Define dimensionless radius of the integration sphere (for precise integration near boundaries)
R = 5;

%%  Define nodal points along the line (1xM nodal points), in meters   
M = 1001;
temp      = linspace(-0.05, 0.05, 1001);
pointsline(1:M, 1) = 0;
pointsline(1:M, 2) = 0;
pointsline(1:M, 3) = temp';   

%%   Write points to the text file
fileID      = fopen('pointsline1.pts', 'w');
for m = 1:size(pointsline, 1)
    fprintf(fileID, '%f%f%f\n', pointsline(m, :));
end
fclose(fileID);

%%  Assign object types to observation points
obsPointCore = assign_tissue_type_volume(pointsline, GEOM.normals, GEOM.Center, Indicator(1:length(GEOM.t)));
in              = obsPointCore > 0;    
out             = obsPointCore == 0; 

%%  Find the H-field
tic
Hpri           = bemf3_inc_field_magnetic(strcoil, pointsline, prec);    
Hsec           = bemf5_volume_field_sa(pointsline, cf, P, t, Center, Area, normals, R, prec);
Htotal         = Hpri + Hsec;   
fieldLineTime = toc  

% %%  Correct the error inside
% tic
% Hinf           = bemf5_volume_field_sa(pointsline(in, :), cf0, P, t, Center, Area, normals, R, prec);
% Herr           = Hpri(in, :) + Hinf; 
% Htotal(in, :)  = Htotal(in, :) - Herr;
% ErrorLineTime = toc

%%   Plot the line in 3D
f1 = figure;
hold on;
bemf1_graphics_coil_CAD(strcoil.P, strcoil.t, 0);
plot3(pointsline(:, 1), pointsline(:, 2), pointsline(:, 3), '-r', 'lineWidth', 2);
view(10, 20);

%%  Core graphics
str.EdgeColor = 'k'; str.FaceColor = 'c'; str.FaceAlpha = 1.0; 
bemf2_graphics_base(P, GEOM.t, str);
camlight; lighting phong;

%%  Graphics for the line
f2 = figure;
hold on;
plot(pointsline(:, 3), +Htotal(:, 1), '-r', 'LineWidth', 2); 
plot(pointsline(:, 3), +Htotal(:, 2), '-m', 'LineWidth', 2); 
plot(pointsline(:, 3), +Htotal(:, 3), '-b', 'LineWidth', 2); 
grid on;

title('Line field H in A/m, red:Hx, magenta:Hy, blue:Hz');
xlabel('Distance z from the origin, m');
ylabel('Magnetic field, H');
set(gcf,'Color','White');

